# References
# https://pgi-jcns.fz-juelich.de/portal/pages/using-c-from-python.html
# https://docs.python.org/3/library/ctypes.html
# https://forums.xilinx.com/t5/Embedded-Linux/Shared-Library-Creation-from-Xilinx-SDK-for-Zynq/td-p/246716

# CMD_READ_REGION  = 0
# CMD_START        = 1
# CMD_TEST_MODE    = 2
# CMD_RESTART      = 3

import ctypes
import os
import time

# Set the needed command parameters
CMD_READ_REGION  = 1
CMD_START        = 2
CMD_TEST_MODE    = 3
CMD_RESTART      = 4
CMD_CLEAR        = 5

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

def wait_for_test_res_ready(port):

    ok = 0

    while(ok == 0):
        cmd = read_cmd(get_reg_address(port, 4))
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

def advance_test(port):

    cmd = write_cmd(get_reg_address(port, 2), str(hex(1)))
    issue_linux_cmd(cmd)

def set_region(region, port):

    print
    print("Setting the region...")
    cmd = write_cmd(get_reg_address(port, 1), str(hex(region)))
    issue_linux_cmd(cmd)

    # Clear out before new write command
    clear_command(port)

    # Write the read region command
    cmd = write_cmd(get_reg_address(port, 0), str(hex(CMD_READ_REGION)))
    issue_linux_cmd(cmd)

    # Wait untill the HW has read the command
    wait_for_cmd_read(port)
    print("Region has been set!")

def set_cmd(command, port):

    # Clear out before new write command
    clear_command(port)

    cmd = write_cmd(get_reg_address(port, 0), str(hex(command)))
    issue_linux_cmd(cmd)

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

    test_hw(port)

def get_done(port):

    cmd = read_cmd(get_reg_address(port, 9))
    res = issue_linux_cmd(cmd)

    return res

def get_cmd_executed(port):

    cmd = read_cmd(get_reg_address(port, 10))
    res = issue_linux_cmd(cmd)

    # CMD_READ_REGION  = 1
    # CMD_START        = 2
    # CMD_TEST_MODE    = 3
    # CMD_RESTART      = 4
    # CMD_CLEAR        = 5

    return res
    
def get_region(port):

    cmd = read_cmd(get_reg_address(port, 1))
    res = issue_linux_cmd(cmd)

    return "%.8x" % res

def get_counter(port):

    global _hw

    cmd = read_cmd(get_reg_address(port, 8))
    low = issue_linux_cmd(cmd)
    cmd = read_cmd(get_reg_address(port, 7))
    high = issue_linux_cmd(cmd)

    return "%.8x" % high + "%.8x" % low

def test_hw(port):

    test = [0, 0]
    res = [0, 0]
    counter = [0, 0]

    nb_tests = 0
    nb_correct = 0

    print
    print("Testing the platform...")
    print

    # First set the region to be used to all zeros
    region = 0x00000000
    set_region(region, port)
    print("Selected region: " + '%.8x' % region)

    # Start the DES engine in test mode
    set_cmd(CMD_TEST_MODE, port)
    print("Starting test mode...")
    wait_for_cmd_read(port)

    # Wait until the first ciphertext result is ready
    wait_for_test_res_ready(port)

    test[1] = 0x8ca64de9
    test[0] = 0xc1b123a7

    cmd = read_cmd(get_reg_address(port, 6))
    res[0] = issue_linux_cmd(cmd)

    cmd = read_cmd(get_reg_address(port, 5))
    res[1] = issue_linux_cmd(cmd)

    nb_tests += 1
    nb_correct += ( (hex(test[1]).rstrip("L") == hex(res[1]).rstrip("L")) & (hex(test[0]).rstrip("L") == hex(res[0]).rstrip("L")) )

    print("Test result:")
    print("Message   : " + '%.8x' % region + "00000000")
    print("Ciphertext: " + '%.8x' % res[1] + '%.8x' % res[0])
    print("Expected  : " + '%.8x' % test[1]+ '%.8x' % test[0])
    print

    #***********************************************************************
    advance_test(port)
    wait_for_test_res_ready(port)

    test[1] = 0x166b40b4
    test[0] = 0x4aba4bd6

    cmd = read_cmd(get_reg_address(port, 6))
    res[0] = issue_linux_cmd(cmd)

    cmd = read_cmd(get_reg_address(port, 5))
    res[1] = issue_linux_cmd(cmd)

    nb_tests += 1
    nb_correct += ( (hex(test[1]).rstrip("L") == hex(res[1]).rstrip("L")) & (hex(test[0]).rstrip("L") == hex(res[0]).rstrip("L")) )

    print("Test result:")
    print("Message   : " + '%.8x' % region + "00000001")
    print("Ciphertext: " + '%.8x' % res[1] + '%.8x' % res[0])
    print("Expected  : " + '%.8x' % test[1]+ '%.8x' % test[0])
    print

    #***********************************************************************
    advance_test(port)
    wait_for_test_res_ready(port)

    test[1] = 0x06e7ea22
    test[0] = 0xce92708f

    cmd = read_cmd(get_reg_address(port, 6))
    res[0] = issue_linux_cmd(cmd)

    cmd = read_cmd(get_reg_address(port, 5))
    res[1] = issue_linux_cmd(cmd)

    nb_tests += 1
    nb_correct += ( (hex(test[1]).rstrip("L") == hex(res[1]).rstrip("L")) & (hex(test[0]).rstrip("L") == hex(res[0]).rstrip("L")) )

    print("Test result:")
    print("Message   : " + '%.8x' % region + "00000002")
    print("Ciphertext: " + '%.8x' % res[1] + '%.8x' % res[0])
    print("Expected  : " + '%.8x' % test[1]+ '%.8x' % test[0])
    print

    #***********************************************************************
    advance_test(port)
    wait_for_test_res_ready(port)

    test[1] = 0x4eb190c9
    test[0] = 0xa2fa169c

    cmd = read_cmd(get_reg_address(port, 6))
    res[0] = issue_linux_cmd(cmd)

    cmd = read_cmd(get_reg_address(port, 5))
    res[1] = issue_linux_cmd(cmd)

    nb_tests += 1
    nb_correct += ( (hex(test[1]).rstrip("L") == hex(res[1]).rstrip("L")) & (hex(test[0]).rstrip("L") == hex(res[0]).rstrip("L")) )

    print("Test result:")
    print("Message   : " + '%.8x' % region + "00000003")
    print("Ciphertext: " + '%.8x' % res[1] + '%.8x' % res[0])
    print("Expected  : " + '%.8x' % test[1]+ '%.8x' % test[0])
    print

    cmd = read_cmd(get_reg_address(port, 8))
    counter[0] = issue_linux_cmd(cmd)

    cmd = read_cmd(get_reg_address(port, 7))
    counter[1] = issue_linux_cmd(cmd)


    print("Testing completed!")
    print("Result: " + '%.8x' % nb_correct + "/"  + '%.8x' % nb_tests + " correct!")
    print("Counter: " + '%.8x' % counter[1] + '%.8x' % counter[0] + ", expected: " + '%.8x' % 0 + '%.8x' % 4)
    print

def restart_hw(port):

    # Clear out before new write command
    clear_command(port)

    # Write the read region command
    cmd = write_cmd(get_reg_address(port, 0), str(hex(CMD_RESTART)))
    issue_linux_cmd(cmd)

    # Wait untill the HW has read the command
    wait_for_cmd_read(port)






