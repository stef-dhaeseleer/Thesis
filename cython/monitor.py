import interface    # Contains all the lower level control functions for communication with the HW.
import time
import os.path

# TODO:
# Make a sample for correct operation.

# Define all the port addresses for passing to the c code
# These are the addresses the CPU writes to to pass data to the DES cores.
# In the current design, 4 DES cores are connected to each of these ports.
# From the user point of view, these are just orderd as numbered 'blocks' representing the different cores.
# Each set of 4 blocks forms thus one port.

#ports = [0x43C00000, 0x43C10000, 0x43C20000, 0x43C30000, 0x43C40000, 0x43C50000, 0x43C60000, 0x43C70000, 0x43C80000, 0x43C90000, 0x43CA0000, 0x43CB0000, 0x43CC0000, 0x43CD0000, 0x43CE0000, 0x43CF0000, 0x43D00000, 0x43D10000, 0x43D20000, 0x43D30000, 0x43D40000, 0x43D50000, 0x43D60000, 0x43D70000, 0x43D80000, 0x43D90000, 0x43DA0000, 0x43DB0000, 0x43DC0000, 0x43DD0000, 0x43DE0000, 0x43DF0000]
#ports = [0x43C00000, 0x43C10000, 0x43C20000, 0x43C30000, 0x43C40000, 0x43C50000, 0x43C60000, 0x43C70000, 0x43C80000, 0x43C90000, 0x43CA0000, 0x43CB0000, 0x43CC0000, 0x43CD0000, 0x43CE0000, 0x43CF0000]
#ports = [0x43C00000, 0x43C10000, 0x43C20000, 0x43C30000, 0x43C40000, 0x43C50000, 0x43C60000, 0x43C70000]
ports = [0x43C00000, 0x43C10000, 0x43C20000, 0x43C30000]
#ports = [0x43C00000, 0x43C10000]

nb_cores_per_port = 4                       # The number of DES cores connected to one port
nb_blocks = len(ports)*nb_cores_per_port    # The total number of DES cores on the board

# Reference: https://users.ece.cmu.edu/~koopman/lfsr/index.html
# These are the polynomials used for each core.
# The current list contains 100 full cycle LFSR polynomials
polynomials = [int('800000000000000D', 16), int('800000000000000E', 16), int('800000000000007A', 16), int('80000000000000BA', 16), int('80000000000000D0', 16), int('80000000000000EF', 16), int('8000000000000128', 16), int('8000000000000165', 16), int('80000000000001A3', 16), int('80000000000001E4', 16), int('80000000000001E7', 16), int('80000000000001F9', 16), int('8000000000000212', 16), int('8000000000000299', 16), int('80000000000003BC', 16), int('80000000000003BF', 16), int('8000000000000403', 16), int('8000000000000472', 16), int('800000000000049C', 16), int('80000000000004C9', 16), int('8000000000000508', 16), int('800000000000056B', 16), int('800000000000057C', 16), int('8000000000000645', 16), int('8000000000000658', 16), int('8000000000000703', 16), int('8000000000000711', 16), int('8000000000000784', 16), int('80000000000007B4', 16), int('80000000000007C9', 16), int('80000000000007F5', 16), int('8000000000000841', 16), int('8000000000000869', 16), int('800000000000089C', 16), int('80000000000008F6', 16), int('8000000000000940', 16), int('8000000000000952', 16), int('8000000000000957', 16), int('800000000000096D', 16), int('8000000000000B22', 16), int('8000000000000B24', 16), int('8000000000000B2D', 16), int('8000000000000B44', 16), int('8000000000000B84', 16), int('8000000000000BA3', 16), int('8000000000000BAF', 16), int('8000000000000BC3', 16), int('8000000000000CBC', 16), int('8000000000000D0F', 16), int('8000000000000D18', 16), int('8000000000000D27', 16), int('8000000000000D71', 16), int('8000000000000DAA', 16), int('8000000000000DDD', 16), int('8000000000000E2E', 16), int('8000000000000E5C', 16), int('8000000000000E82', 16), int('8000000000000EB7', 16), int('8000000000000EC3', 16), int('8000000000000EFA', 16), int('8000000000000FC1', 16), int('8000000000000FE3', 16), int('800000000000101B', 16), int('800000000000102B', 16), int('8000000000001036', 16), int('80000000000010CA', 16), int('80000000000010F0', 16), int('800000000000114C', 16), int('800000000000115E', 16), int('800000000000117F', 16), int('80000000000011D5', 16), int('80000000000011E5', 16), int('8000000000001237', 16), int('8000000000001238', 16), int('800000000000125E', 16), int('80000000000012DF', 16), int('8000000000001324', 16), int('8000000000001335', 16), int('8000000000001395', 16), int('8000000000001410', 16), int('800000000000143D', 16), int('800000000000147C', 16), int('80000000000014C1', 16), int('80000000000014F8', 16), int('800000000000155C', 16), int('80000000000015B7', 16), int('80000000000015D1', 16), int('8000000000001618', 16), int('8000000000001713', 16), int('8000000000001797', 16), int('80000000000017AE', 16), int('8000000000001858', 16), int('8000000000001868', 16), int('80000000000018F8', 16), int('8000000000001933', 16), int('800000000000193A', 16), int('800000000000196C', 16), int('800000000000198B', 16), int('80000000000019A9', 16), int('80000000000019E2', 16)]

# All the files needed
res_file_path = "/home/root/reports/results.txt"        # The results (counters) are stored here
status_file_path = "/home/root/reports/status.txt"      # The status of the blocks is stored here
param_file_path = "/home/root/reports/param.txt"        # The parameters (masks, nb of encryptions) are stored here
key_file_path = "/home/root/reports/key.txt"            # The subkeys for each core

# This list is written to the status file and read from there
# This information is used by the CPU to know wheter a block is currently running or idle.
# It also alows to recover the block status when the control PC has been disconnected and Python needs to be restarted
#       Value in list set to '1' when a block is activated
#       Value in list set to '0' when a block is restarted
blocks_status = [0] * nb_blocks

# This list contains the seed a block is currently using.
# This is used when writing the results to the result file.
seeds = [0] * nb_blocks

# This variable contains the last used seed.
last_seed = 0x00000000

# This function opens the status file and reads the current status of all the blocks into the blocks_status list
#       Value in list set to '1' when a block is activated
#       Value in list set to '0' when a block is restarted
def read_status():

    blocks_status = []

    with open(status_file_path, "r") as f:
        for line in f:
            blocks_status.append(int(line.strip()))

    return blocks_status

# This functions writes the current block status from the blocks_status list into the status file 
# It also alows to recover the block status when the control PC has been disconnected and Python needs to be restarted
# as the last known status has been written to this file.
def write_status(blocks_status):

    with open(status_file_path, "w") as f:
        for status in blocks_status:
            f.write(str(status) +"\n")

# This function initializes the platform.
# It creates the result and status file.
# It prints the current parameters or prompts the user for parameters when no parameter file is present.
def init_platform():

    print
    print("Initializing the plaform...")
    
    f_res = open(res_file_path, 'w+')
    f_res.write("POLYNOMIAL : SEED : COUNTER RESULT" +"\n")
    
    f = open(status_file_path, 'w+')
    
    for nb in range(0, nb_blocks):
        f.write(str(0) +"\n")

    if (os.path.isfile(param_file_path) == 0):
        print ("No parameters file found, will create the file now and ask for input!")
        set_parameters()
    else:
        print("A parameter file was found on the system, will print the current parameters...")
        print_parameters()
        print("If these are not correct, change the file or use set_parameters() or set_nb_encryptions()!")

    if (os.path.isfile(key_file_path) == 0):
        print ("No key file found! Make one before continuing !!!")
        
    print("Platform initialized!")    

# This function prompts the user for the input/output mask parameters and the number of encryptions to be performed.
# These parameters are then saved into the parameter file to use when setting up the DES cores.
def set_parameters():
    print
    print("Will prompt for parameters now...")
    print("For all " + str(nb_blocks) + " cores:")

    # Prompt user for input
    input_mask = input('Input mask (hex): ')
    output_mask = input('Ouput mask (hex): ')
    nb_encryptions = input('Number of encryptions needed per core (hex): ')

    file = open(param_file_path, 'w')

    # Write new values to file
    file.write(str(input_mask) + "\n")
    file.write(str(output_mask) + "\n")
    file.write(str(nb_encryptions) + "\n")

    file.close()

    print("Parameter file generated!")

# This functions prompts the user to input a new value for the number of encryptions to be performed.
# This is the only value for the parameters that will be changed, the input and output mask will remain the same.
def set_nb_encryptions():
    print
    print("Will prompt for number of encryptions now...")

    if (os.path.isfile(param_file_path) == 0):
        print ("No parameters file found, you can create one with set_parameters()!")
        return

    # Prompt user for input
    nb_encryptions = input('Number of encryptions needed (hex): ')

    file = open(param_file_path, 'r')

    # Save the current input and output mask
    input_mask = file.readline()
    output_mask = file.readline()
    
    file.close()
    file = open(param_file_path, 'w')

    # Write old and new values to file
    file.write(input_mask)
    file.write(output_mask)
    file.write(str(nb_encryptions) + "\n")

    file.close()

    print("Parameter file generated!")

# Prints the current parameters in the parameter file
def print_parameters():
    print
    
    if (os.path.isfile(param_file_path) == 0):
        print ("No parameters file found, you can create one with set_parameters()!")
        return
    
    file = open(param_file_path, 'r')

    input_mask = file.readline()
    output_mask = file.readline()
    nb_encryptions = file.readline() 

    print("Input mask        : 0x" + str(input_mask))
    print("Output mask       : 0x" + str(output_mask))
    print("Nb of encryptions : 0x" + str(nb_encryptions))

    file.close()

# Prints the current status of all the DES cores.
# IDLE:     block is waiting to be started (first set all parameters).
# WORKING:  block is currently working on the requested number of encryptions.
# DONE:     block is finished on the requested number of encryptions, waiting for results to be processed.     
def get_hw_status():

    print
    print("REPORTING BLOCK STATUS: ")
    print

    status = 0

    # First read the latest status from the status file
    blocks_status = read_status()

    # Report for every block if it is: IDLE, WORKING, DONE
    for i in range(0, nb_blocks):

        status = 0
        core_nb = i%nb_cores_per_port   # The core number is the result of modulo nb_cores_per_port

        if (blocks_status[i] == 0):                 # In this case the block is idle.
            print ("BLOCK " + str(i) + ": IDLE")
        else:                                       # In this case the block has been started, check if it is done.
            # If the block is done, report DONE
            # Else report WORKING
            status = interface.get_done(get_port(i), core_nb)
            
            seed = str(seeds[i])

            if (status == 0):
                print("BLOCK " + str(i) + ": WORKING on seed 0x" + seed)
            else:
                print("BLOCK " + str(i) + ": DONE on seed 0x" + seed)

# Starts the block with the given number on the given seed.
# The initialization with the parameters is done automatically if all parameters have been set, else the sequence is aborted.
#
# Keys are fetched from the key file.
# The input/output mask and number of encryptions are fetched from the parameters file.
# The polynomial is fetched from the polynomials list.
#
# After the initialization, the block is started and the block status is updated.
def start_des(block_nb, seed):

    blocks_status = read_status()
    
    # First check if block is not currently active!
    # Else abort
    if (blocks_status[block_nb] == 1):
        print ("Block " + str(block_nb) + " is currently active, let it finish before starting it again or restart it!")
        return
    
    # Check if the seed is not zero (bad for LFSR).
    # Else abort
    if (seed == 0):
        print ("Input seed cannot be zero as this will yield only zero outputs from the LFSR!")
        return

    # Abort if no parameter file is present.
    if (os.path.isfile(param_file_path) == 0):
        print ("No parameters file found, you can create one with set_parameters()!")
        return

    # Abort if no key file is present.
    if (os.path.isfile(key_file_path) == 0):
        print ("No key file found, you should upload one first before attempting to start!")
        return

    # Now that we know the files are present, open them.
    file = open(param_file_path, 'r')
    key_file = open(key_file_path, 'r')

    # Get the port and the core number within that port.
    port = get_port(block_nb)
    core_nb = block_nb%nb_cores_per_port

    # Get all necessary parameters from the files.
    seeds[block_nb] = seed
    polynomial = polynomials[block_nb]
    input_mask = int(file.readline(), 16)
    output_mask = int(file.readline(), 16)
    nb_encryptions = int(file.readline(), 16)

    # Generate the list of round keys to be set.
    keys = [0] * 16

    # Skip 16 keys and one empty line.
    # Do this for all preceding block numbers (skip their respective round keys).
    for i in range(0, block_nb*17):
        key_file.readline()

    # Read 16 keys for the current block.
    for i in range(0, 16):
        keys[i] = int(key_file.readline(), 16)

    # First set the parameters and keys for the block 
    # Then start the block given the block_nb and the seed to operate on 
    interface.set_params(seed, polynomial, input_mask, output_mask, nb_encryptions, port, core_nb)
    interface.set_keys(keys, port, core_nb)
    interface.start_block(port, core_nb)

    # Update the last_seed and blocks_status for the current block
    blocks_status[block_nb] = 1 
    last_seed = seed

    # Write the new status to the status file
    write_status(blocks_status)

    print ("Core started!")

# Start all the blocks on the board consecutively.
# The seeds are incremented starting for the base seed given as an input.
def start_all(base_seed):

    seed = base_seed
    
    # Check if the first seed is zero, abort if true (bad for LFSR)
    if (seed == 0):
        print ("Input seed cannot be zero as this will yield only zero outputs from the LFSR!")
        return

    # Loop through all the blocks and start them
    # Increment the seed every time
    for nb in range(0, nb_blocks):
        print
        print("Starting core " + str(nb+1) + "/" + str(nb_blocks) + "...")
        start_des(nb, seed)
        seed += 1
        #time.sleep(0.1)
    
    print
    print ("All cores started!")

# Restart a block after the results have been processed.
# The resulting counter value of the block will not be accessible after this.
# After this operation, the block can be started with a new seed or even new parameters.
def restart_des(block_nb):

    port = get_port(block_nb)
    core_nb = block_nb%nb_cores_per_port
    
    # Start a new block given the block_nb and the seed to operate on 
    interface.restart_block(port, core_nb)

    # Update the last_seed and blocks_status
    blocks_status = read_status()
    blocks_status[block_nb] = 0
    write_status(blocks_status)

# Function that verifies if the HW functions correctly with sanity checks.
# Currently this function is not used anymore (testing removed from HW design to save space). 
def test_hw_functionality():

    # TODO: make a new test for the HW (1)

    # Perform standard test on HW by testing the first block
    # All information for functionality verfication will be printed to the terminal
    # interface.test_block(ports[0])
    
    restart_des(0)

# This function processes the results.
# If the DES cores are done with their operations, the counter results are read.
# These results are then written into the result file to process the later.
def get_results_des(block_nb):

    blocks_status = read_status()

    port = get_port(block_nb)
    core_nb = block_nb%nb_cores_per_port

    polynomial = str(polynomials[block_nb])
    seed = str(seeds[block_nb])

    # First check if block is currently active!
    if (blocks_status[block_nb] == 0):
        print ("Block " + str(block_nb) + " is currently inactive! Cannot get results")
        return
    else:
        status = interface.get_done(port, core_nb)

        if (status == 0):
            print("Block " + str(block_nb) + " is not done yet! Cannot get results")
            return

    # Process the results of the block and write them to the results file
    res = interface.get_counter(port, core_nb)   # Returns a string

    file = open(res_file_path, 'aw')    # Append and write to the file
    file.write(polynomial + " : " + seed + " : " + res +"\n") 
    file.close() 
    
    restart_des(block_nb)

# Process the results for all blocks.
# Only the blocks that are done with their operations will be processed, others are ignored.
def get_results_all():

    for nb in range(0, nb_blocks):
        print
        print("Getting results of core " + str(nb+1) + "/" + str(nb_blocks) + "...")
	    get_results_des(nb)
        #time.sleep(0.1)

# This function prints the contents of the results file to the terminal.
# This way the user can quickly check the latest results if needed.
def print_results():

    print
    print("The results from the results file will now be printed here...")
    print
    
    # Open the file
    f = open(res_file_path, 'r')

    lines = f.read().splitlines()
    
    # Print all the lines
    for line in lines:
        print(line)

# This function prints the value of the last seed used in the result file.
# This can be used by the user as a reference for choosing future seeds.
def get_last_seed():

    # Print the current value of the last_seed variable
    # But also print the latest used seed in the results file

    f = open(res_file_path, 'r')

    # Use 'with' if this doesn't work
    lines = f.read().splitlines()
    if(len(lines) != 0):
        last_line = lines[-1]   # This gives us the last line in the file
        res_seed = last_line.split()[1]   # The second part is the seed
    else:
        res_seed = "/"

    # Now print the results to the terminal
    print
    print("Last seed in results file: 0x" + res_seed)

# This function returns the port that corresponds to a given block number.
def get_port(block_nb):

    # Cores are clustered per nb_cores_per_port on each core address
    # So devision by four gives the port address
    # Modulo four then gives the core number within that address

    index = block_nb//nb_cores_per_port
    port = ports[index]

    return port

# This resets the entire system.
# All DES cores are restarted, the results file is emptied.
def reset_system():

    # Reset all the cores
    for nb in range(0, nb_blocks):
        restart_des(nb)

    # Open and reset all files
    open(res_file_path, 'w').close() # Opening without 'a' append mode will overwrite with empty file
    
    # Block status to all zeros
    blocks_status = [0] * nb_blocks

    write_status(blocks_status)

# This function prints stats on how long the operations on the board will taks for the current settings.
def performance_stats():
    
    clock_freq = 100    # Clock frequency in MHz
    seconds_per_day = 24*60*60

    # First check if the parameter file exists
    if (os.path.isfile(param_file_path) == 0):
        print ("Parameter file is empty, you can create one with set_parameters()!")
        return

    # Now that we know the file is present, open it.
    file = open(param_file_path, 'r')

    # Get the number of encryptions to be done from the file.
    file.readline()
    file.readline()

    # Stats per core
    nb_encryptions_core = int(file.readline(), 16)
    two_exp_nb_encryptions_core = math.log(nb_encryptions, 2)

    # Stats for all cores on the board together
    nb_encryptions_total = int(file.readline(), 16) * nb_blocks
    two_exp_nb_encryptions_total = math.log(nb_encryptions, 2)

    # Total encryptions done on the board in one day.
    encrypt_per_day = nb_blocks * clock_freq * 10**6 * seconds_per_day
    two_exp = math.log(encrypt_per_day, 2)

    # Time to complete the operations for the entire board in both hours and days.
    days_for_board = nb_encryptions_total / float(encrypt_per_day)
    hours_for_board = days_for_board * float(24)

    print 
    print ("################################################################################")
    print 

    print ("Clock frequency                : " + str(clock_freq))
    print ("DES cores                      : " + str(nb_blocks))
    print ("Encryptions to be done (core)  : " + str(nb_encryptions_core))
    print ("    2 exponent                 : " + str(two_exp_nb_encryptions_core))
    print ("Encryptions to be done (board) : " + str(nb_encryptions_total))
    print ("    2 exponent                 : " + str(two_exp_nb_encryptions_total))
    print ("Encryptions per day (board)    : " + str(encrypt_per_day))
    print ("    2 exponent                 : " + str(two_exp))
    print

    print ("Time for board complete        : ")
    print ("    days                       : " + str(days_for_board))
    print ("    hours                      : " + str(hours_for_board))

# This function prints an overview of all functions present that the user can use.
# This can used as a quick reference while using the platform.
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
    print("    args: block_nb, seed")
    print("    output: /")
    print("    Starts the specified core number for the specified seed with the preset LFSR polynomial.")
    
    print
    print("start_all()")
    print("    args: base_seed")
    print("    output: /")
    print("    Starts all cores for the specified seed (incremented with one for every new core).")

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
    print("get_results_all()")
    print("    args: /")
    print("    output: /")
    print("    Gets the results from all cores.")

    print
    print("get_last_seed()")
    print("    args: /")
    print("    output: /")
    print("    Gets the last seed used in the results file.")

    print
    print("reset_system()")
    print("    args: /")
    print("    Resets all the cores.")
    print("    Resets the results and status files for new operation.")
    
    print
    print("init_platform()")
    print("    args: /")
    print("    Initializes the platform and creates all the necessary files.")
    
    print
    print("set_parameters()")
    print("    args: /")
    print("    Initializes the parameter file, will prompt the user to input the hex values.")
    
    print
    print("print_parameters()")
    print("    args: /")
    print("    Prints the values for the parameters currently set in the parameters file.")
    
    print
    print("set_nb_encryptions()")
    print("    args: /")
    print("    Change the value for the number of encryptions to be performed in the parameter file.")

    print
    print("performance_stats()")
    print("    args: /")
    print("    This functions print stats on how long the operations will take to complete for the current settings.")

    # print
    # print("name")
    # print("    args: ")
    # print("    output: ")
    # print("    Docu.")


