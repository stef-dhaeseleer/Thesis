# REFERENCE
# This file is used to generate test vectors and verify the working of our DES Verilog engine
# https://medium.com/@urwithajit9/how-to-teach-des-using-python-the-easy-way-part-1-des-subkey-generation-bb5a853ef9b0
# https://medium.com/@urwithajit9/how-to-teach-des-using-python-the-easy-way-part-2-round-function-f-285dd3aef34d
# https://medium.com/@urwithajit9/how-to-teach-des-using-python-the-easy-way-part-3-des-encryption-4394a935effc

import random

PC1_values = [57,49,41,33,25,17,9,1,58,50,42,34,26,18,10,2,59,51,43,35,27,19,11,3,60,52,44,36,63,55,47,39,31,23,15,7,62,54,46,38,30,22,14,6,61,53,45,37,29,21,13,5,28,20,12,4]
PC2_values = [14,17,11,24,1,5,3,28,15,6,21,10,23,19,12,4,26,8,16,7,27,20,13,2, 41,52,31,37,47,55,30,40,51,45,33,48,44,49,39,56,34,53,46,42,50,36,29,32]
round_shifts = [1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1]

def PC1(pc1_values, master_key):

	full_key = ""
	for index in pc1_values:
		full_key += master_key[index-1] # Minus 1 needed to map values in table to Python indexing
	return full_key

def split_key(full_key):

	left_key, right_key = full_key[:28],full_key[28:]

	return left_key, right_key

def circular_left_shift(bits, shift_amount):

	shifted_bits = bits[shift_amount:] + bits[:shift_amount]

	return shifted_bits

def PC2(pc2_values, full_key):

	round_key = ""

	for index in pc2_values:
 		round_key += full_key[index-1] # Minus 1 needed to map values in table to Python indexing

	return round_key

def generate_keys(master_key):

	round_keys = list()

	pc1_res = PC1(PC1_values, master_key) 
	C0,D0 = split_key(pc1_res)

	for round_num in range(16):
		C_new = circular_left_shift(C0, round_shifts[round_num])
		D_new = circular_left_shift(D0, round_shifts[round_num])

		roundkey = PC2(PC2_values, C_new + D_new)
		round_keys.append(roundkey)

		C0 = C_new
		D0 = D_new

	return round_keys

def gen_single_key_file():

    #master_key = "0001001100110100010101110111100110011011101111001101111111110001"
    master_key = "0000000100010011101110010111000011111101001101001111001011001110"
    round_keys = generate_keys(master_key)

    print
    print ("################################################################################")
    print

    file = open("testfiles/subkey_generator.txt", "w")
    file2 = open("testfiles/subkey_verilog.txt", "w")
 
    file.write(master_key + " " + round_keys[0] + " " + round_keys[1] + " " + round_keys[2] + " " + round_keys[3] + " " + round_keys[4] + " " + round_keys[5] + " " + round_keys[6] + " " + round_keys[7] + " " + round_keys[8] + " " + round_keys[9] + " " + round_keys[10] + " " + round_keys[11] + " " + round_keys[12] + " " + round_keys[13] + " " + round_keys[14] + " " + round_keys[15]) 
    file2.write(master_key + "\n")
    file2.write(round_keys[0] + round_keys[1] + round_keys[2] + round_keys[3] + round_keys[4] + round_keys[5] + round_keys[6] + round_keys[7] + round_keys[8] + round_keys[9] + round_keys[10] + round_keys[11] + round_keys[12] + round_keys[13] + round_keys[14] + round_keys[15]) 

    file.close()
    file2.close()

    print ("File generated!")

    print

def gen_32_key_file():

    file = open("../key_set.tcl", "w")
    file_key = open("testfiles/key_vals.txt", "aw")

    file.write("set count 0 \n")
    file.write("set name \"des_axi_8_rounds_\" \n")
    file.write("\n")

    for i in range(0, 32):
        file.write("set a $name$count \n")

        master_key = "{0:b}".format(random.getrandbits(128))
        round_keys = generate_keys(master_key)

        key = round_keys[0] + round_keys[1] + round_keys[2] + round_keys[3] + round_keys[4] + round_keys[5] + round_keys[6] + round_keys[7] + round_keys[8] + round_keys[9] + round_keys[10] + round_keys[11] + round_keys[12] + round_keys[13] + round_keys[14] + round_keys[15]
     
        file.write("set_property -dict [list CONFIG.key_select {\"" + key + "\"}] [get_bd_cells $a] \n") 
        file.write("set_property -dict [list CONFIG.region {32}] [get_bd_cells  $a] \n")
        file.write("incr count \n")
        file.write("\n")

        file_key.write(key + "\n")
    
    file_key.write("\n")

    file.close()
    file_key.close()

    print

    print ("File generated!")
    print ("Run following command to check for duplicate keys: ")
    print ("sort testfiles/key_vals.txt | uniq -d")

    print  

        
         

def main():
    
    gen_32_key_file()

if __name__ == '__main__':
    main()

