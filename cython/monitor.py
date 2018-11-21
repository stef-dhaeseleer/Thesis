import interface.py

# Define all the port addresses for passing to the c code
ports = [0x43C00000, 0x43C10000]

nb_blocks = len(ports)

# If this doesn't work, write status to a file
# Value in list set to '1' when a block is activated
# Value in list set to '0' when a block is restarted
blocks_status = [0] * nb_blocks

file_path = "/mnt/reports/results.txt"

last_region = 0x00000000

def get_hw_status():

    print()
    print("REPORTING BLOCK STATUS: ")
    print()

    status = 0

    # Report for every block if it is: IDLE, WORKING, DONE
    for i in range(0, nb_blocks):

        status = 0

        if (blocks_status[i] == 0):
            print ("BLOCK " + str(i) + ": IDLE")
        else:
            status = interface.get_done(ports[i])

            if (status == 0):
                print("BLOCK " + str(i) + ": WORKING")
            else:
                print("BLOCK " + str(i) + ": DONE")

def test_hw_functionality():

    # Perform standard test on HW by testing the first block
    # All information for functionality verfication will be printed to the terminal
    interface.test_block(ports[0])

def start_des(block_nb, region):
    
    # First check if block is not currently active!
    if (blocks_status[i] == 1):
        print ("Block " + str(block_nb) + " is currently active, let it finish before starting it again or restart it!")
        return

    port = ports[block_nb]
    
    # Start a new block given the block_nb and the region to operate on 
    set_region(region, port)
    start_block(port)

    # Update the last_region and blocks_status
    blocks_status[block_nb] = 1 
    last_region = region

    print ()
    print ("Everything updated!")

def restart_des(block_nb):

    port = ports[block_nb]
    
    # Start a new block given the block_nb and the region to operate on 
    restart_block(port)

    # Update the last_region and blocks_status
    blocks_status[block_nb] = 0 
    
    print ()
    print ("Everything updated!")

def get_results_des(block_nb):

    port = ports[block_nb]

    # First check if block is currently active!
    if (blocks_status[i] == 0):
        print ("Block " + str(block_nb) + " is currently inactive! Cannot get results")
        return
    else:
        status = interface.get_done(port)

        if (status == 0):
            print("Block " + str(block_nb) + " is currently not done yet! Cannot get results")
            return

    # Process the results of the block and write them to the results file

    region = get_region(port)
    high, low = get_counter(port)

    file = open(file_path, 'aw')    # Append and write to the file
    file.write(str(hex(region)) + " : " + str(high) + str(low)) 
    file.close() 

    print ()
    print ("All results processed, the block will now be restarted!")
    
    restart_des(block_nb)

