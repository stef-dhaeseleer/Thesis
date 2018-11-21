import ctypes

# Set the data for the C shared object library

#_hw = ctypes.CDLL('./libhw.so')


#_hw.test_hw.argtypes = (ctypes.POINTER(ctypes.c_uint))
#_hw.restart_hw.argtypes = (ctypes.POINTER(ctypes.c_uint))
#_hw.start_hw.argtypes = (ctypes.c_uint16, ctypes.POINTER(ctypes.c_uint))
#_hw.monitor_hw.argtypes = (ctypes.POINTER(ctypes.c_uint))

# Set the needed command parameters
CMD_READ_REGION  = 0
CMD_START        = 1
CMD_TEST_MODE    = 2
CMD_RESTART      = 3


# Now make the python functions to wrap around these c functions

def test_hw(port):

    global _hw

    # Set the region, set the command and wait for command read
    _hw.test_hw(ctypes.POINTER(ctypes.c_uint(port)))

def restart_hw(port):

    global _hw

    # Set the region, set the command and wait for command read
    _hw.restart_hw(ctypes.POINTER(ctypes.c_uint(port)))

def start_hw_wait_finish(region, port):

    global _hw

    print()
    print("Starting the HW...")

    # Set the region, set the command and wait for command read
    _hw.start_hw(ctypes.c_uint16(region), ctypes.POINTER(ctypes.c_uint(port)))
