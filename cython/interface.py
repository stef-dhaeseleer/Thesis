# References
# https://pgi-jcns.fz-juelich.de/portal/pages/using-c-from-python.html
# https://docs.python.org/3/library/ctypes.html
# https://forums.xilinx.com/t5/Embedded-Linux/Shared-Library-Creation-from-Xilinx-SDK-for-Zynq/td-p/246716

# CMD_READ_SEED   = 1
# CMD_READ_POLY   = 2
# CMD_START       = 3
# CMD_RESTART     = 5

import ctypes
import os
import time

# Set the needed command parameters

CMD_READ_SEED   = 1
CMD_READ_POLY   = 2
CMD_START       = 3
CMD_RESTART     = 5

CMD_CLEAR       = 9

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

def write_cmd(address, value):
    
    #print("devmem " + address + " W " + value)
    return "devmem " + address + " W " + value

def read_cmd(address):

    return "devmem " + address + " W"

def get_reg_address(port, reg_nb):

    # Reg address = port base + 4*reg_nb

    return str(hex(port + 4*reg_nb))

def wait_for_cmd_read(port):

    ok = 0

    while(ok == 0):
        cmd = read_cmd(get_reg_address(port, 3))
        ok = issue_linux_cmd(cmd)

def clear_command(port):

    # This function is a dummy command to make sure that the command read is set back to zero
    # before we write a new command to the AXI

    cmd = write_cmd(get_reg_address(port, 0), str(hex(CMD_CLEAR)))
    issue_linux_cmd(cmd)

    ok = 1  # Init to 1

    # Loop untill this becomes zero and we are thus sure we can write a new command to the AXI
    while(ok == 1):
        cmd = read_cmd(get_reg_address(port, 3))
        ok = issue_linux_cmd(cmd)

def set_cmd(command, port):

    # Clear out before new write command
    clear_command(port)

    cmd = write_cmd(get_reg_address(port, 0), str(hex(command)))
    issue_linux_cmd(cmd)

def set_params(seed, polynomial, port):

    seed_low = seed & 0xFFFFFFFF
    seed_high = seed >> 32

    polynomial_low = polynomial & 0xFFFFFFFF
    polynomial_high = polynomial >> 32

    print
    print("Setting the parameters...")

    ####### SEED
    cmd = write_cmd(get_reg_address(port, 1), str(hex(seed_high)))
    issue_linux_cmd(cmd)

    cmd = write_cmd(get_reg_address(port, 2), str(hex(seed_low)))
    issue_linux_cmd(cmd)

    # Clear out before new write command
    clear_command(port)

    # Write the read region command
    cmd = write_cmd(get_reg_address(port, 0), str(hex(CMD_READ_SEED)))
    issue_linux_cmd(cmd)

    # Wait untill the HW has read the command
    wait_for_cmd_read(port)
    print("Seed has been set!")

    ####### POLYNOMIAL
    cmd = write_cmd(get_reg_address(port, 1), str(hex(polynomial_high)))
    issue_linux_cmd(cmd)

    cmd = write_cmd(get_reg_address(port, 2), str(hex(polynomial_low)))
    issue_linux_cmd(cmd)

    # Clear out before new write command
    clear_command(port)

    # Write the read region command
    cmd = write_cmd(get_reg_address(port, 0), str(hex(CMD_READ_POLY)))
    issue_linux_cmd(cmd)

    # Wait untill the HW has read the command
    wait_for_cmd_read(port)
    print("Polynomial has been set!")

def start_block(port):

    print
    print("Starting the block...")

    # Clear out before new write command
    clear_command(port)

    # Set the command
    cmd = write_cmd(get_reg_address(port, 0), str(hex(CMD_START)))
    issue_linux_cmd(cmd)   

    # Wait untill the HW has read the command
    wait_for_cmd_read(port)

    print("Block has been started!")

def restart_block(port):

    print
    print("Restarting the HW...")

    restart_hw(port)

def test_block(port):

    print
    print("Starting TEST MODE...")

    # TODO: Should make a new test (1)
    #test_hw(port)

def get_done(port):

    cmd = read_cmd(get_reg_address(port, 6))
    res = issue_linux_cmd(cmd)

    return res

def get_counter(port):

    global _hw

    cmd = read_cmd(get_reg_address(port, 5))
    low = issue_linux_cmd(cmd)
    cmd = read_cmd(get_reg_address(port, 4))
    high = issue_linux_cmd(cmd)

    return "%.8x" % high + "%.8x" % low

def test_hw(port):

    # TODO: Should make a new test (1)

def restart_hw(port):

    # Clear out before new write command
    clear_command(port)

    # Write the read region command
    cmd = write_cmd(get_reg_address(port, 0), str(hex(CMD_RESTART)))
    issue_linux_cmd(cmd)

    # Wait untill the HW has read the command
    wait_for_cmd_read(port)






