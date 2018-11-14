import interface.py as interface

# Define all the port addresses for passing to the c code
ports = [0x43C00000, 0x43C10000]

nb_blocks = len(ports)

# If this doesn't work, write status to a file
# Value in list set to '1' when a block is activated
# Value in list set to '0' when a block is restarted
blocks_status = [0] * nb_blocks

def get_hw_status():

    print()
    print("REPORTING BLOCK STATUS: ")
    print()

    status = 0

    # Report for every block if it is: IDLE, WORKING, DONE
    for i in range(0, nb_blocks)

        status = 0

        if (blocks_status[i] == 0)
            print ("BLOCK " + str(i) + ": IDLE")
        else
            status = interface.get_done(ports[i])

            if (status == 0)
                print("BLOCK " + str(i) + ": WORKING")
            else
                print("BLOCK " + str(i) + ": DONE")

def test_hw():

    # Perform standard test on HW by testing the first block
    interface.test_block(ports[0])
