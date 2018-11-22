# References
# https://pgi-jcns.fz-juelich.de/portal/pages/using-c-from-python.html
# https://docs.python.org/3/library/ctypes.html
# https://forums.xilinx.com/t5/Embedded-Linux/Shared-Library-Creation-from-Xilinx-SDK-for-Zynq/td-p/246716

# CMD_READ_REGION  = 0
# CMD_START        = 1
# CMD_TEST_MODE    = 2
# CMD_RESTART      = 3

import ctypes

# Set the data for the C shared object library

_hw = ctypes.cdll.LoadLibrary('/home/root/cython/libhw.so')
#_hw = ctypes.CDLL('/home/root/cython/libhw.so')
#_hw = ctypes.CDLL('./mylib.so')

_hw.interface_init.argtypes = []

_hw.set_cmd.argtypes = [ctypes.c_uint, ctypes.POINTER(ctypes.c_uint)]
_hw.set_region.argtypes = [ctypes.c_uint16, ctypes.POINTER(ctypes.c_uint)]
_hw.advance_test.argtypes = [ctypes.POINTER(ctypes.c_uint)]

_hw.print_reg_contents.argtypes = [ctypes.POINTER(ctypes.c_uint)]

_hw.wait_for_cmd_read.argtypes = [ctypes.POINTER(ctypes.c_uint)]
_hw.wait_for_test_res_ready.argtypes = [ctypes.POINTER(ctypes.c_uint)]
_hw.wait_for_done.argtypes = [ctypes.POINTER(ctypes.c_uint)]

_hw.get_done.argtypes = [ctypes.POINTER(ctypes.c_uint)]
_hw.get_region.argtypes = [ctypes.POINTER(ctypes.c_uint)]
_hw.get_counter_lower.argtypes = [ctypes.POINTER(ctypes.c_uint)]
_hw.get_counter_upper.argtypes = [ctypes.POINTER(ctypes.c_uint)]

_hw.test_hw.argtypes = [ctypes.POINTER(ctypes.c_uint)]
_hw.restart_hw.argtypes = [ctypes.POINTER(ctypes.c_uint)]
_hw.start_hw.argtypes = [ctypes.c_uint16, ctypes.POINTER(ctypes.c_uint)]
_hw.monitor_hw.argtypes = [ctypes.POINTER(ctypes.c_uint)]


# Set the needed command parameters
CMD_READ_REGION  = 0
CMD_START        = 1
CMD_TEST_MODE    = 2
CMD_RESTART      = 3


# Now make the python functions to wrap around these c functions

def set_region(region, port):

    global _hw

    port_point = ctypes.cast(port, ctypes.POINTER(ctypes.c_uint))

    print
    print("Setting the region...")
    # Set the region, set the command and wait for command read
    #_hw.set_region(ctypes.c_uint16(region), ctypes.c_uint(port))
    _hw.set_region(ctypes.c_uint16(region), port_point)
    print("1...")
    #_hw.set_cmd(ctypes.c_uint(CMD_READ_REGION), ctypes.c_uint(port))
    _hw.set_cmd(ctypes.c_uint(CMD_READ_REGION), port_point)
    print("2...")
    #_hw.print_reg_contents(ctypes.c_uint(port))
    #_hw.wait_for_cmd_read(ctypes.c_uint(port))
    _hw.print_reg_contents(port_point)
    _hw.wait_for_cmd_read(port_point)
    print("Region has been set!")

def start_block(port):

    global _hw

    port_point = ctypes.cast(port, ctypes.POINTER(ctypes.c_uint))

    print
    print("Starting the block...")

    _hw.set_cmd(ctypes.c_uint(CMD_START), ctypes.byref(ctypes.c_uint(port)))
    _hw.wait_for_cmd_read(ctypes.byref(ctypes.c_uint(port)))

    print("Block has been started!")

def restart_block(port):

    global _hw

    print
    print("Restarting the HW...")

    restart_hw(port)

def test_block(port):

    global _hw

    print
    print("Starting TEST MODE...")

    test_hw(port)


def get_done(port):

    global _hw

    return int(_hw.get_done(ctypes.byref(ctypes.c_uint(port))))

def get_region(port):

    global _hw

    return int(_hw.get_region(ctypes.byref(ctypes.c_uint(port))))

def get_counter(port):

    global _hw

    low = int(_hw.get_counter_lower(ctypes.byref(ctypes.c_uint(port))))
    high = int(_hw.get_counter_uppper(ctypes.byref(ctypes.c_uint(port))))

    return high, low

def test_hw(port):

    global _hw

    # Set the region, set the command and wait for command read
    _hw.test_hw(ctypes.byref(ctypes.c_uint(port)))

def restart_hw(port):

    global _hw

    # Set the region, set the command and wait for command read
    _hw.restart_hw(ctypes.byref(ctypes.c_uint(port)))

def start_hw_wait_finish(region, port):

    global _hw

    print
    print("Starting the HW...")

    # Set the region, set the command and wait for command read
    _hw.start_hw(ctypes.c_uint16(region), ctypes.byref(ctypes.c_uint(port)))






