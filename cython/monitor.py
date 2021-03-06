import interface

# Define all the port addresses for passing to the c code
ports = [0x43C00000, 0x43C10000]

nb_blocks = len(ports)

res_file_path = "/home/root/reports/results.txt"
status_file_path = "/home/root/reports/status.txt"

# This list is written to the status file and read from there
# Value in list set to '1' when a block is activated
# Value in list set to '0' when a block is restarted
blocks_status = [0] * nb_blocks

last_region = 0x00000000

def read_status():

    blocks_status = []

    with open(status_file_path, "r") as f:
        for line in f:
            blocks_status.append(int(line.strip()))

    return blocks_status

def write_status(blocks_status):

    with open(status_file_path, "w") as f:
        for status in blocks_status:
            f.write(str(status) +"\n")

def init_platform():

    print
    print("Initializing the plaform...")
    
    f_res = open(res_file_path, 'w+')
    f_res.write("REGION : COUNTER RESULT" +"\n")
    
    f = open(status_file_path, 'w+')
    
    for nb in range(0, nb_blocks):
        f.write(str(0) +"\n")
        
    print("Platform initialized!")
    
def get_hw_status():

    print
    print("REPORTING BLOCK STATUS: ")
    print

    status = 0

    blocks_status = read_status()

    # Report for every block if it is: IDLE, WORKING, DONE
    for i in range(0, nb_blocks):

        status = 0

        if (blocks_status[i] == 0):
            print ("BLOCK " + str(i) + ": IDLE")
        else:
            status = interface.get_done(ports[i])
            
            region = interface.get_region(ports[i]) # Returns a string

            if (status == 0):
                print("BLOCK " + str(i) + ": WORKING on region 0x" + region)
            else:
                print("BLOCK " + str(i) + ": DONE on region 0x" + region)

def start_des(block_nb, region):

    blocks_status = read_status()
    
    # First check if block is not currently active!
    if (blocks_status[block_nb] == 1):
        print ("Block " + str(block_nb) + " is currently active, let it finish before starting it again or restart it!")
        return

    port = ports[block_nb]
    
    # Start a new block given the block_nb and the region to operate on 
    interface.set_region(region, port)
    interface.start_block(port)

    # Update the last_region and blocks_status
    blocks_status[block_nb] = 1 
    last_region = region

    write_status(blocks_status)

    print
    print ("Everything updated!")

def restart_des(block_nb):

    port = ports[block_nb]
    
    # Start a new block given the block_nb and the region to operate on 
    interface.restart_block(port)

    # Update the last_region and blocks_status
    blocks_status = read_status()
    blocks_status[block_nb] = 0
    write_status(blocks_status)
    
    print
    print ("Everything updated!")
    
def test_hw_functionality():

    # Perform standard test on HW by testing the first block
    # All information for functionality verfication will be printed to the terminal
    interface.test_block(ports[0])
    
    restart_des(0)

def get_results_des(block_nb):

    blocks_status = read_status()

    port = ports[block_nb]

    # First check if block is currently active!
    if (blocks_status[block_nb] == 0):
        print ("Block " + str(block_nb) + " is currently inactive! Cannot get results")
        return
    else:
        status = interface.get_done(port)

        if (status == 0):
            print("Block " + str(block_nb) + " is not done yet! Cannot get results")
            return

    # Process the results of the block and write them to the results file

    region = interface.get_region(port) # Returns a string
    res = interface.get_counter(port)   # Returns a string

    file = open(res_file_path, 'aw')    # Append and write to the file
    file.write(region + " : " + res +"\n") 
    file.close() 

    print
    print ("All results processed, the block will now be restarted!")
    
    restart_des(block_nb)

def print_results():

    print
    print("The results from the results file will now be printed here...")
    print
    
    f = open(res_file_path, 'r')

    # Use 'with' if this doesn't work
    lines = f.read().splitlines()
    
    for line in lines:
        print(line)

def get_last_region():

    # Print the current value of the last_region variable
    # But also print the latest region used region in the results file

    f = open(res_file_path, 'r')

    # Use 'with' if this doesn't work
    lines = f.read().splitlines()
    if(len(lines) != 0):
        last_line = lines[-1]   # This gives us the last line in the file
        res_region = last_line.split()[0]   # The first part is the region
    else:
        res_region = "/"

    # Now print the results to the terminal
    print
    print("Last region in results file: 0x" + res_region)

def reset_system():

    # Reset all the cores
    for nb in range(0, nb_blocks):
        restart_des(nb)

    # Open and reset all files
    open(res_file_path, 'w').close() # Opening without 'a' append mode will overwrite with empty file
    
    # Block status to all zeros
    blocks_status = [0] * nb_blocks

    write_status(blocks_status)

def help():

    # This is a help function that prints an overview of the commands
    print
    print("DES cryptanalysis platform")
    print("Number of cores: " + str(nb_blocks))

    print
    print("Function overview:")

    # Function overview
    print
    print("get_hw_status()")
    print("    args: /")
    print("    output: /")
    print("    Prints a status overview of all the DES cores.")
    print("    Possible states are: IDLE, RUNNING, DONE.")

    print
    print("test_hw_functionality()")
    print("    args: /")
    print("    output: /")
    print("    Will perform tests on first core to see if all functionalities are working.")
    print("    The output will be printed to allow user verification.")

    print
    print("start_des()")
    print("    args: block_nb, region")
    print("    output: /")
    print("    Starts the specified core number for the specified region.")

    print
    print("restart_des()")
    print("    args: block_nb")
    print("    output: /")
    print("    Restarts the specified core number, all progress on that core will be lost.")

    print
    print("get_results_des()")
    print("    args: block_nb")
    print("    output: /")
    print("    Gets the results from the specified core when it has finished.")
    print("    The results are written to the results file.")

    print
    print("get_last_region()")
    print("    args: /")
    print("    output: /")
    print("    Prints the last_region variable of the code and gets the last region used in the results file.")

    print
    print("reset_system()")
    print("    args: /")
    print("    Resets all the cores.")
    print("    Resets the results and status files for new operation.")
    
    print
    print("init_platform()")
    print("    args: /")
    print("    Initializes the platform and creates all the necessary files.")

    # print
    # print("name")
    # print("    args: ")
    # print("    output: ")
    # print("    Docu.")


