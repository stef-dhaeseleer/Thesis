# References
# https://pgi-jcns.fz-juelich.de/portal/pages/using-c-from-python.html
# https://docs.python.org/3/library/ctypes.html
# https://forums.xilinx.com/t5/Embedded-Linux/Shared-Library-Creation-from-Xilinx-SDK-for-Zynq/td-p/246716

# COMMANDS
#
# CMD_READ_SEED            = 1
# CMD_READ_POLY            = 2
# CMD_READ_INPUT_MASK      = 3
# CMD_READ_OUTPUT_MASK     = 4
# CMD_READ_COUNTER_LIMIT   = 5
# CMD_READ_ROUNDKEY        = 6
# CMD_START                = 7
# CMD_RESTART              = 8

# REGISTER NUMBERS
# The first 3 and the last are data sent to the HW logic.
# The middle 4 are data sent back from the HW logic.
#
# CMD               1       The command sent to the HW
# DATA_UPPER        2       The upper part of the data sent to the HW
# DATA_LOWER        3       The lower part of the data sent to the HW
#
# CMD_READ          4       Signals when the HW has read and processed the command
# COUNTER_UPPER     5       The upper part of the resulting counter
# COUNTER_LOWER     6       The lower part of the resulting counter
# DONE              7       Signals when the HW operations are done

# CORE_NB           8       Signals to the interface what core number for that port we want to communicate with  

import ctypes
import os
import time

# Set the needed command parameters

CMD_READ_SEED            = 1    # Reads the 64 bit seed from the two data register
CMD_READ_POLY            = 2    # Reads the 64 bit polynomial from the two data register
CMD_READ_INPUT_MASK      = 3    # Reads the 64 bit input mask from the two data register
CMD_READ_OUTPUT_MASK     = 4    # Reads the 64 bit output mask from the two data register
CMD_READ_COUNTER_LIMIT   = 5    # Reads the 64 bit seed counter limit (number of encryptions) the two data register
CMD_READ_ROUNDKEY        = 6    # Reads the 48 bit round key from the two data register (shift reg implementation, roundkey 1 first and 16 last)
CMD_START                = 7    # Starts the operation of the HW
CMD_RESTART              = 8    # Restarts the HW (only do this after the results have been processed or they will be lost)

CMD_CLEAR                = 9    # This command does not exist in HW, it is only used here for a full reset of the CMD register

# This function takes a string containing the Linux terminal command to be executed.
# This string is than executed by this function and the result is returned if not empty.
def issue_linux_cmd(cmd):

    resp = os.popen(cmd).read()
    resp = resp[0:len(resp)-1]

    if(resp != ""):
        res = int(resp, 16)
        #time.sleep(0.2)
        return res
    else:
        #time.sleep(0.2)
        return 0

# This function returns a string containing a command for writing data.
# The inputs to this function are expected to be strings.
# The data to be written is inputted as 'value'
# The address to write it to is inputted as 'address'
def write_cmd(address, value):
    
    #print("devmem " + address + " W " + value)
    return "devmem " + address + " W " + value.strip('L')

# This function returns a string containing a command for reading data.
# The input to this function are expected to be strings.
# The address to read from is inputted as 'address'
def read_cmd(address):

    return "devmem " + address + " W"

# This function returns the address of a register for a given interface.
# The base addrees of the interface is inputted as 'port'.
# The wanted register number is inputted as 'reg_nb'.
# The output is a string representing the wanted address, this can directly be used with the "..._cmd" functions.
def get_reg_address(port, reg_nb):

    # Reg address = port base + 4*reg_nb
    return str(hex(port + 4*reg_nb))

# This functions read the CMD_READ register of the given port.
# It will only exit when the command has been read and thus the HW has processed the requested command.
def wait_for_cmd_read(port):

    ok = 0

    counter = 0
    
    time.sleep(0.01)

    while(ok == 0): # command not read as long as this remains zero.
        cmd = read_cmd(get_reg_address(port, 3))
        ok = issue_linux_cmd(cmd)
        counter += 1

        if (counter == 200):
            print ("Operation failed, wait CMD_READ timeout!")
            return

        time.sleep(0.01)

# This function writes and executes the clear command.
# This forces the CMD_READ register to become zero and avoids any faulty operations due to synchronization issues.
def clear_command(port):

    # This function is a dummy command to make sure that the command read is set back to zero
    # before we write a new command to the AXI

#    cmd = write_cmd(get_reg_address(port, 0), str(hex(CMD_CLEAR)))
#    issue_linux_cmd(cmd)

#    ok = 1  # Init to 1
    
#    counter = 0

#    time.sleep(0.01)

    # Loop untill this becomes zero and we are thus sure we can write a new command to the AXI
#    while(ok == 1):
#        cmd = read_cmd(get_reg_address(port, 3))
#        ok = issue_linux_cmd(cmd)
#        counter += 1
#        
#        if (counter == 200):
#            print ("CMD clear failed, timeout!")
#            return
#            
#        time.sleep(0.01)

    time.sleep(0.01)

# This function writes a command to a given port.
# The command is passed as 'command'.
# The port is passed as 'port'.
def set_cmd(command, port):

    # Clear out before new write command
    clear_command(port)

    cmd = write_cmd(get_reg_address(port, 0), str(hex(command)))
    issue_linux_cmd(cmd)

# This functions sets all the given parameters for the given core on the given interface (port).
# port: the base address of the port to write the data to.
# core_nb: The number (int) of the core of the given port to write the data to.
# seed: The seed value to write to the port (int).
# polynomial: The polynomial value to write to the port (int).
# input_mask: The input mask value to write to the port (int).
# output_mask: The output mask value to write to the port (int).
# nb_encryptions: The number of encryptions value to write to the port (int).
def set_params(seed, polynomial, input_mask, output_mask, nb_encryptions, port, core_nb):

    # Split all the variables to be writtin into their upper and lower 32 bits.
    # This is needed to write them to the DATA_UPPER and DATA_LOWER interface.
    seed_low = seed & 0xFFFFFFFF
    seed_high = seed >> 32

    polynomial_low = polynomial & 0xFFFFFFFF
    polynomial_high = polynomial >> 32

    input_mask_low = input_mask & 0xFFFFFFFF
    input_mask_high = input_mask >> 32

    output_mask_low = output_mask & 0xFFFFFFFF
    output_mask_high = output_mask >> 32

    nb_encryptions_low = nb_encryptions & 0xFFFFFFFF
    nb_encryptions_high = nb_encryptions >> 32

    print("Setting the parameters...")

    # First tell the interface what core number we want to write data to.
    # This value stays set, so we can move to setting all the data.
    set_core_nb(port, core_nb)

    # For all the parameters.
    # First write the upper and the lower data register.
    # Then write the command for the HW to read this data.
    # Then wait untill the HW has read the command before moving on to the next one.

    ####### SEED #######
    cmd = write_cmd(get_reg_address(port, 1), str(hex(seed_high)))
    issue_linux_cmd(cmd)

    cmd = write_cmd(get_reg_address(port, 2), str(hex(seed_low)))
    issue_linux_cmd(cmd)

    # Clear out before new write command
    clear_command(port)

    # Write the read seed command
    cmd = write_cmd(get_reg_address(port, 0), str(hex(CMD_READ_SEED)))
    issue_linux_cmd(cmd)

    # Wait untill the HW has read the command
    wait_for_cmd_read(port)

    ####### POLYNOMIAL #######
    cmd = write_cmd(get_reg_address(port, 1), str(hex(polynomial_high)))
    issue_linux_cmd(cmd)

    cmd = write_cmd(get_reg_address(port, 2), str(hex(polynomial_low)))
    issue_linux_cmd(cmd)

    # Clear out before new write command
    clear_command(port)

    # Write the read polynomial command
    cmd = write_cmd(get_reg_address(port, 0), str(hex(CMD_READ_POLY)))
    issue_linux_cmd(cmd)

    # Wait untill the HW has read the command
    wait_for_cmd_read(port)

    ####### INPUT MASK #######
    cmd = write_cmd(get_reg_address(port, 1), str(hex(input_mask_high)))
    issue_linux_cmd(cmd)

    cmd = write_cmd(get_reg_address(port, 2), str(hex(input_mask_low)))
    issue_linux_cmd(cmd)

    # Clear out before new write command
    clear_command(port)

    # Write the read input mask command
    cmd = write_cmd(get_reg_address(port, 0), str(hex(CMD_READ_INPUT_MASK)))
    issue_linux_cmd(cmd)

    # Wait untill the HW has read the command
    wait_for_cmd_read(port)

    ####### OUTPUT MASK #######
    cmd = write_cmd(get_reg_address(port, 1), str(hex(output_mask_high)))
    issue_linux_cmd(cmd)

    cmd = write_cmd(get_reg_address(port, 2), str(hex(output_mask_low)))
    issue_linux_cmd(cmd)

    # Clear out before new write command
    clear_command(port)

    # Write the read output mask command
    cmd = write_cmd(get_reg_address(port, 0), str(hex(CMD_READ_OUTPUT_MASK)))
    issue_linux_cmd(cmd)

    # Wait untill the HW has read the command
    wait_for_cmd_read(port)

    ####### NB ENCRYPTIONS #######
    cmd = write_cmd(get_reg_address(port, 1), str(hex(nb_encryptions_high)))
    issue_linux_cmd(cmd)

    cmd = write_cmd(get_reg_address(port, 2), str(hex(nb_encryptions_low)))
    issue_linux_cmd(cmd)

    # Clear out before new write command
    clear_command(port)

    # Write the read counter limit command
    cmd = write_cmd(get_reg_address(port, 0), str(hex(CMD_READ_COUNTER_LIMIT)))
    issue_linux_cmd(cmd)

    # Wait untill the HW has read the command
    wait_for_cmd_read(port)

# This functions sets all 16 roundkeys needed for operation.
# port: the base address of the port to write the data to.
# core_nb: The number (int) of the core of the given port to write the data to.
# keys: list containing all 16 roundkeys to be set.
def set_keys(keys, port, core_nb):

    # Keys is a list containing all 16 round keys, form key1 to key16
    # The HW accepts key1 first and key16 last in order

    print("Setting the roundkeys...")

    # First tell the interface what core number we want to write data to.
    # This value stays set, so we can move to setting all the data.
    set_core_nb(port, core_nb)

    # Loop over all key values
    for key in keys:
        # Split all the variables to be written into their upper and lower 32 bits.
        # This is needed to write them to the DATA_UPPER and DATA_LOWER interface.
        key_low = key & 0xFFFFFFFF
        key_high = key >> 32

        # Write the data to the respective data registers
        cmd = write_cmd(get_reg_address(port, 1), str(hex(key_high)))
        issue_linux_cmd(cmd)

        cmd = write_cmd(get_reg_address(port, 2), str(hex(key_low)))
        issue_linux_cmd(cmd)

        # Clear out before new write command
        clear_command(port)

        # Write the read region command
        cmd = write_cmd(get_reg_address(port, 0), str(hex(CMD_READ_ROUNDKEY)))
        issue_linux_cmd(cmd)

        # Wait untill the HW has read the command
        wait_for_cmd_read(port)

# Start the given block on the given port.
def start_block(port, core_nb):

    print("Starting the block...")

    # First tell the interface what core number we want to write data to.
    set_core_nb(port, core_nb)

    # Clear out before new write command
    clear_command(port)

    # Set the command
    cmd = write_cmd(get_reg_address(port, 0), str(hex(CMD_START)))
    issue_linux_cmd(cmd)   

    # Wait untill the HW has read the command
    wait_for_cmd_read(port)

# Restart the given block on the given port.
def restart_block(port, core_nb):

    print("Restarting the HW...")

    # First tell the interface what core number we want to write data to.
    set_core_nb(port, core_nb)

    restart_hw(port)

# Testint currently not implemented.
# Testing HW functionality has been removed to save space.
def test_block(port, core_nb):

    print("Starting TEST MODE...")

    # TODO: Should make a new test (1)
    #test_hw(port)

# Get the value from the DONE register for the given block on the given port.
def get_done(port, core_nb):

    # First tell the interface what core number we want to get data from.
    set_core_nb(port, core_nb)

    cmd = read_cmd(get_reg_address(port, 6))
    res = issue_linux_cmd(cmd)

    return res

# Get the value from the COUNTER registers (upper and lower) for the given block on the given port.
def get_counter(port, core_nb):

    # First tell the interface what core number we want to get data from.
    set_core_nb(port, core_nb)

    cmd = read_cmd(get_reg_address(port, 5))
    low = issue_linux_cmd(cmd)
    cmd = read_cmd(get_reg_address(port, 4))
    high = issue_linux_cmd(cmd)

    return "%.8x" % high + "%.8x" % low

# This function writes the core number we want to communicate with to the port interface.
# This tells the interface what core we want to write and read data from.
def set_core_nb(port, core_nb):

    # This function is a dummy command to make sure that the command read is set back to zero
    # before we write a new command to the AXI

    cmd = write_cmd(get_reg_address(port, 7), str(hex(core_nb)))
    issue_linux_cmd(cmd)

    clear_command(port)

# This writes the restart command to the given port.
def restart_hw(port):

    # Clear out before new write command
    clear_command(port)

    # Write the read region command
    cmd = write_cmd(get_reg_address(port, 0), str(hex(CMD_RESTART)))
    issue_linux_cmd(cmd)

    # Wait untill the HW has read the command
    wait_for_cmd_read(port)






