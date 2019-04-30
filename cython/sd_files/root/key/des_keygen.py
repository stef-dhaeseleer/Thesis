# REFERENCE
# This file is used to generate test vectors and verify the working of our DES Verilog engine
# https://medium.com/@urwithajit9/how-to-teach-des-using-python-the-easy-way-part-1-des-subkey-generation-bb5a853ef9b0
# https://medium.com/@urwithajit9/how-to-teach-des-using-python-the-easy-way-part-2-round-function-f-285dd3aef34d
# https://medium.com/@urwithajit9/how-to-teach-des-using-python-the-easy-way-part-3-des-encryption-4394a935effc

import random
import sys

PC1_values = [57,49,41,33,25,17,9,1,58,50,42,34,26,18,10,2,59,51,43,35,27,19,11,3,60,52,44,36,63,55,47,39,31,23,15,7,62,54,46,38,30,22,14,6,61,53,45,37,29,21,13,5,28,20,12,4]
PC2_values = [14,17,11,24,1,5,3,28,15,6,21,10,23,19,12,4,26,8,16,7,27,20,13,2, 41,52,31,37,47,55,30,40,51,45,33,48,44,49,39,56,34,53,46,42,50,36,29,32]
round_shifts = [1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1]

def hexTobinary(hexdigits):

	binarydigits = ""

	for hexdigit in hexdigits:
		binarydigits += bin(int(hexdigit,16))[2:].zfill(4)

	return binarydigits

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

def gen_192_key_file_random_full_platform():

    file_key = open("reduced_round/new_key_vals.txt", "aw")
    file_sd = open("reduced_round/key.txt", "w")

    for i in range(0, 192):

        master_key = "{0:016x}".format(random.getrandbits(64))
        key_bits = hexTobinary(master_key)
        round_keys = generate_keys(key_bits)

        key = round_keys[0] + round_keys[1] + round_keys[2] + round_keys[3] + round_keys[4] + round_keys[5] + round_keys[6] + round_keys[7] + round_keys[8] + round_keys[9] + round_keys[10] + round_keys[11] + round_keys[12] + round_keys[13] + round_keys[14] + round_keys[15]

        for j in range(0, 16):   
            #file_sd.write(hex(int(round_keys[j], 2)) + "\n")
            
            file_sd.write('{:012x}'.format(int(round_keys[j], 2)) + "\n")
            
        file_key.write(key + "\n")
        file_sd.write("\n")
    
    file_key.write("\n")
    file_sd.write("\n")

    file_key.close()
    file_sd.close()

    print

    print ("File generated!")
    print ("Location: key/reduced_round/key.txt")
    print ("Run following command to check for duplicate keys: ")
    print ("sort reduced_round/new_key_vals.txt | uniq -d")

    print
    
def gen_zero_correlation_key_file_full_platform():

    file_sd = open("zero_corr/key.txt", "w")
    file_key = open("zero_corr/key_used.txt", "r")
    
    round_keys = [0] * 16
    
    for k in range(0, 16):
        round_keys[k] = file_key.readline()
        

    for i in range(0, 128):

        for j in range(0, 16):   
            file_sd.write(round_keys[j])
            
        file_sd.write("\n")
    
    file_sd.write("\n")

    file_key.close()
    file_sd.close()

    print

    print ("File generated!")
    print ("Location: key/zero_corr/key.txt")

    print
         

def main(argv):
    
    # Reduced round key generation
    #gen_192_key_file_random_full_platform()
    
    # Zero correlation key generation
    #gen_zero_correlation_key_file_full_platform()
    
    #gen_32_key_file()
    
    if argv[0] == 'zero_corr':
        print('Zero correlation key generation...')
        print('')
        gen_zero_correlation_key_file_full_platform()
        
    elif argv[0] == 'reduced_round':
        print('Reduced round random key generation...')
        print('')
        gen_192_key_file_random_full_platform()
    
    else :
        print('Not a valid option, valid options are: ')
        print('zero_corr')
        print('reduced_round')
        print('')

if __name__ == '__main__':
    main(sys.argv[1:])

