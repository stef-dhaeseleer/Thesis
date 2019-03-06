import interface
import time
import os.path

# Define all the port addresses for passing to the c code
#ports = [0x43C00000, 0x43C10000, 0x43C20000, 0x43C30000, 0x43C40000, 0x43C50000, 0x43C60000, 0x43C70000, 0x43C80000, 0x43C90000, 0x43CA0000, 0x43CB0000, 0x43CC0000, 0x43CD0000, 0x43CE0000, 0x43CF0000, 0x43D00000, 0x43D10000, 0x43D20000, 0x43D30000, 0x43D40000, 0x43D50000, 0x43D60000, 0x43D70000, 0x43D80000, 0x43D90000, 0x43DA0000, 0x43DB0000, 0x43DC0000, 0x43DD0000, 0x43DE0000, 0x43DF0000]
#ports = [0x43C00000, 0x43C10000, 0x43C20000, 0x43C30000, 0x43C40000, 0x43C50000, 0x43C60000, 0x43C70000, 0x43C80000, 0x43C90000, 0x43CA0000, 0x43CB0000, 0x43CC0000, 0x43CD0000, 0x43CE0000, 0x43CF0000]
ports = [0x43C00000, 0x43C10000, 0x43C20000, 0x43C30000]
#ports = [0x43C00000, 0x43C10000]
nb_cores_per_port = 4
nb_blocks = len(ports)*nb_cores_per_port

# Reference: https://users.ece.cmu.edu/~koopman/lfsr/index.html
polynomials = [int('800000000000000D', 16), int('800000000000000E', 16), int('800000000000007A', 16), int('80000000000000BA', 16), int('80000000000000D0', 16), int('80000000000000EF', 16), int('8000000000000128', 16), int('8000000000000165', 16), int('80000000000001A3', 16), int('80000000000001E4', 16), int('80000000000001E7', 16), int('80000000000001F9', 16), int('8000000000000212', 16), int('8000000000000299', 16), int('80000000000003BC', 16), int('80000000000003BF', 16), int('8000000000000403', 16), int('8000000000000472', 16), int('800000000000049C', 16), int('80000000000004C9', 16), int('8000000000000508', 16), int('800000000000056B', 16), int('800000000000057C', 16), int('8000000000000645', 16), int('8000000000000658', 16), int('8000000000000703', 16), int('8000000000000711', 16), int('8000000000000784', 16), int('80000000000007B4', 16), int('80000000000007C9', 16), int('80000000000007F5', 16), int('8000000000000841', 16), int('8000000000000869', 16), int('800000000000089C', 16), int('80000000000008F6', 16), int('8000000000000940', 16), int('8000000000000952', 16), int('8000000000000957', 16), int('800000000000096D', 16), int('8000000000000B22', 16), int('8000000000000B24', 16), int('8000000000000B2D', 16), int('8000000000000B44', 16), int('8000000000000B84', 16), int('8000000000000BA3', 16), int('8000000000000BAF', 16), int('8000000000000BC3', 16), int('8000000000000CBC', 16), int('8000000000000D0F', 16), int('8000000000000D18', 16), int('8000000000000D27', 16), int('8000000000000D71', 16), int('8000000000000DAA', 16), int('8000000000000DDD', 16), int('8000000000000E2E', 16), int('8000000000000E5C', 16), int('8000000000000E82', 16), int('8000000000000EB7', 16), int('8000000000000EC3', 16), int('8000000000000EFA', 16), int('8000000000000FC1', 16), int('8000000000000FE3', 16), int('800000000000101B', 16), int('800000000000102B', 16), int('8000000000001036', 16), int('80000000000010CA', 16), int('80000000000010F0', 16), int('800000000000114C', 16), int('800000000000115E', 16), int('800000000000117F', 16), int('80000000000011D5', 16), int('80000000000011E5', 16), int('8000000000001237', 16), int('8000000000001238', 16), int('800000000000125E', 16), int('80000000000012DF', 16), int('8000000000001324', 16), int('8000000000001335', 16), int('8000000000001395', 16), int('8000000000001410', 16), int('800000000000143D', 16), int('800000000000147C', 16), int('80000000000014C1', 16), int('80000000000014F8', 16), int('800000000000155C', 16), int('80000000000015B7', 16), int('80000000000015D1', 16), int('8000000000001618', 16), int('8000000000001713', 16), int('8000000000001797', 16), int('80000000000017AE', 16), int('8000000000001858', 16), int('8000000000001868', 16), int('80000000000018F8', 16), int('8000000000001933', 16), int('800000000000193A', 16), int('800000000000196C', 16), int('800000000000198B', 16), int('80000000000019A9', 16), int('80000000000019E2', 16)]

res_file_path = "/home/root/reports/results.txt"
status_file_path = "/home/root/reports/status.txt"
param_file_path = "/home/root/reports/param.txt"
key_file_path = "/home/root/reports/key.txt"

# This list is written to the status file and read from there
# Value in list set to '1' when a block is activated
# Value in list set to '0' when a block is restarted
blocks_status = [0] * nb_blocks
seeds = [0] * nb_blocks

last_seed = 0x00000000

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
    f_res.write("POLYNOMIAL : SEED : COUNTER RESULT" +"\n")
    
    f = open(status_file_path, 'w+')
    
    for nb in range(0, nb_blocks):
        f.write(str(0) +"\n")
        
    print("Platform initialized!")

    print
    print("Do not forget to use set_parameters() if no parameters file is present already!")

def set_parameters():
    print
    print("Will prompt for parameters now...")

    input_mask = input('Input mask (hex): ')
    output_mask = input('Ouput mask (hex): ')
    nb_encryptions = input('Number of encryptions needed (hex): ')

    file = open(param_file_path, 'w')

    file.write(str(input_mask) + "\n")
    file.write(str(output_mask) + "\n")
    file.write(str(nb_encryptions) + "\n")

    file.close()

    print("Parameter file generated!")

def set_nb_encryptions():
    print
    print("Will prompt for number of encryptions now...")

    if (os.path.isfile(param_file_path) == 0):
        print ("Parameter file is empty, you can create one with set_parameters()!")
        return

    nb_encryptions = input('Number of encryptions needed (hex): ')

    file = open(param_file_path, 'r')

    input_mask = file.readline()
    output_mask = file.readline()
    
    file.close()
    file = open(param_file_path, 'w')

    file.write(input_mask)
    file.write(output_mask)
    file.write(str(nb_encryptions) + "\n")

    file.close()

    print("Parameter file generated!")

def print_parameters():
    print
    print("Will print the parameters now...")
    
    if (os.path.isfile(param_file_path) == 0):
        print ("Parameter file is empty, you can create one with set_parameters()!")
        return
    
    file = open(param_file_path, 'r')

    input_mask = file.readline()
    output_mask = file.readline()
    nb_encryptions = file.readline() 

    print("Input mask        : 0x" + str(input_mask))
    print("Output mask       : 0x" + str(output_mask))
    print("Nb of encryptions : 0x" + str(nb_encryptions))

    file.close()
    
def get_hw_status():

    print
    print("REPORTING BLOCK STATUS: ")
    print

    status = 0

    blocks_status = read_status()

    # Report for every block if it is: IDLE, WORKING, DONE
    for i in range(0, nb_blocks):

        status = 0
        core_nb = i%nb_cores_per_port   # The core number is the result of modulo nb_cores_per_port

        if (blocks_status[i] == 0):
            print ("BLOCK " + str(i) + ": IDLE")
        else:
            status = interface.get_done(get_port(i), core_nb)
            
            seed = str(seeds[i])

            if (status == 0):
                print("BLOCK " + str(i) + ": WORKING on seed 0x" + seed)
            else:
                print("BLOCK " + str(i) + ": DONE on seed 0x" + seed)

def start_des(block_nb, seed):

    blocks_status = read_status()
    
    # First check if block is not currently active!
    if (blocks_status[block_nb] == 1):
        print ("Block " + str(block_nb) + " is currently active, let it finish before starting it again or restart it!")
        return
    
    # Check if the seed is not zero (bad for LFSR)
    if (seed == 0):
        print ("Input seed cannot be zero as this will yield only zero outputs from the LFSR!")
        return

    if (os.path.isfile(param_file_path) == 0):
        print ("Parameter file is empty, you can create one with set_parameters()!")
        return

    if (os.path.isfile(key_file_path) == 0):
        print ("Key file is empty, you should upload one first before attempting to start!")
        return

    file = open(param_file_path, 'r')
    key_file = open(key_file_path, 'r')

    port = get_port(block_nb)
    core_nb = block_nb%nb_cores_per_port

    seeds[block_nb] = seed
    polynomial = polynomials[block_nb]
    input_mask = int(file.readline(), 16)
    output_mask = int(file.readline(), 16)
    nb_encryptions = int(file.readline(), 16)

    keys = [0] * 16

    # Skip 16 keys and one empty line (previous block_nb keys)
    for i in range(0, block_nb*17):
        key_file.readline()

    # Read 16 keys
    for i in range(0, 16):
        keys[i] = int(key_file.readline(), 16)
    
    # Start a new block given the block_nb and the seed to operate on 
    interface.set_params(seed, polynomial, input_mask, output_mask, nb_encryptions, port, core_nb)
    interface.set_keys(keys, port, core_nb)
    interface.start_block(port, core_nb)

    # Update the last_seed and blocks_status
    blocks_status[block_nb] = 1 
    last_seed = seed

    write_status(blocks_status)

    print ("Core started!")

def start_all(base_seed):

    seed = base_seed
    
    if (seed == 0):
        print ("Input seed cannot be zero as this will yield only zero outputs from the LFSR!")
        return

    for nb in range(0, nb_blocks):
        print
        print("Starting core " + str(nb+1) + "/" + str(nb_blocks) + "...")
	    start_des(nb, seed)
	    seed += 1
        #time.sleep(0.1)
    
    print
    print ("All cores started!")

def restart_des(block_nb):

    port = get_port(block_nb)
    core_nb = block_nb%nb_cores_per_port
    
    # Start a new block given the block_nb and the seed to operate on 
    interface.restart_block(port, core_nb)

    # Update the last_seed and blocks_status
    blocks_status = read_status()
    blocks_status[block_nb] = 0
    write_status(blocks_status)
    
    print
    print ("Everything updated!")
    
def test_hw_functionality():

    # TODO: make a new test for the HW (1)

    # Perform standard test on HW by testing the first block
    # All information for functionality verfication will be printed to the terminal
    # interface.test_block(ports[0])
    
    restart_des(0)

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

    print
    print ("All results processed, the block will now be restarted!")
    
    restart_des(block_nb)

def get_results_all():

    for nb in range(0, nb_blocks):
	    get_results_des(nb)
        #time.sleep(0.1)

def print_results():

    print
    print("The results from the results file will now be printed here...")
    print
    
    f = open(res_file_path, 'r')

    # Use 'with' if this doesn't work
    lines = f.read().splitlines()
    
    for line in lines:
        print(line)

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

def get_port(block_nb):

    # Cores are clustered per nb_cores_per_port on each core address
    # So devision by four gives the port address
    # Modulo four then gives the core number within that address

    index = block_nb//nb_cores_per_port
    port = ports[index]

    return port

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

    # print
    # print("name")
    # print("    args: ")
    # print("    output: ")
    # print("    Docu.")


