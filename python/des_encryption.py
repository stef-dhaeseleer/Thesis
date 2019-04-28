# REFERENCE
# This file is used to generate test vectors and verify the working of our DES Verilog engine
# https://medium.com/@urwithajit9/how-to-teach-des-using-python-the-easy-way-part-1-des-subkey-generation-bb5a853ef9b0
# https://medium.com/@urwithajit9/how-to-teach-des-using-python-the-easy-way-part-2-round-function-f-285dd3aef34d
# https://medium.com/@urwithajit9/how-to-teach-des-using-python-the-easy-way-part-3-des-encryption-4394a935effc

from des_functions import *
from des_keygen import *

import binascii

def DES_encrypt(message, key, file, file_2):

	cipher = ""

	# Convert hex digits to binary
	plaintext_bits = hexTobinary(message)
	key_bits = hexTobinary(key)

	# KS
	roundkeys = generate_keys(key_bits)
	
	# IP
	p_plaintext = apply_initial_p(INITIAL_PERMUTATION_TABLE,plaintext_bits)

	# split
	L,R = spliHalf(p_plaintext)

	# Roundfunctions
	for round in range(16):

		newR = XOR(L,functionF(R, roundkeys[round]))
		newL = R

		file.write(roundkeys[round] + " " + L + " " + R + " " + newL + " " + newR + "\n")
		file_2.write(roundkeys[round])

		R = newR	# Switch the parts to initialize the next round
		L = newL

	cipher = apply_initial_p(INVERSE_PERMUTATION_TABLE, R+L) # Input the parts in reverse order for this last operation

	return cipher
	
def DES_encrypt(message, key, file):

	cipher = ""

	# Convert hex digits to binary
	plaintext_bits = hexTobinary(message)
	key_bits = hexTobinary(key)

	# KS
	roundkeys = generate_keys(key_bits)
	
	# IP
	p_plaintext = apply_initial_p(INITIAL_PERMUTATION_TABLE,plaintext_bits)

	# split
	L,R = spliHalf(p_plaintext)

	# Roundfunctions
	for round in range(16):

		newR = XOR(L,functionF(R, roundkeys[round]))
		newL = R

		file.write(roundkeys[round] + " " + L + " " + R + " " + newL + " " + newR + "\n")

		R = newR	# Switch the parts to initialize the next round
		L = newL

	cipher = apply_initial_p(INVERSE_PERMUTATION_TABLE, R+L) # Input the parts in reverse order for this last operation

	return cipher

def DES_encrypt(message, key):

	cipher = ""

	# Convert hex digits to binary
	plaintext_bits = hexTobinary(message)
	key_bits = hexTobinary(key)

	# KS
	roundkeys = generate_keys(key_bits)
	
	# IP
	p_plaintext = apply_initial_p(INITIAL_PERMUTATION_TABLE,plaintext_bits)

	# split
	L,R = spliHalf(p_plaintext)

	# Roundfunctions
	for round in range(16):

		newR = XOR(L,functionF(R, roundkeys[round]))
		newL = R

		R = newR	# Switch the parts to initialize the next round
		L = newL

	cipher = apply_initial_p(INVERSE_PERMUTATION_TABLE, R+L) # Input the parts in reverse order for this last operation

	return cipher	

def DES_encrypt_reduced(message, key):

	cipher = ""

	# Convert hex digits to binary
	plaintext_bits = hexTobinary(message)
	key_bits = hexTobinary(key)

	# KS
	roundkeys = generate_keys(key_bits)

	# split
	L,R = spliHalf(plaintext_bits)

    # Roundfunctions
	for round in range(8):

		newR = XOR(L,functionF(R, roundkeys[round]))
		newL = R

		R = newR	# Switch the parts to initialize the next round
		L = newL
		
		print(round+1)
		print(hex(int(R, 2)))
		print(hex(int(L, 2)))

	cipher = R+L # Input the parts in reverse order for this last operation

	return cipher

def generate_test_files_NIST():

	print ("Started making test files...")

	file = open("testfiles/roundfunction_tests.txt", "w")

	file_2 = open("testfiles/des_tests.txt", "w")

	file_input = open("testfiles/des_test_vectors.txt", "r")

	for line in file_input:

		args = line.split()

		master_key = args[0]
		message = args[1]
		expected = args[2]

		ciphertext = DES_encrypt(message, master_key, file, file_2)

		if (hexTobinary(expected) != ciphertext):
			print ("RESULT WRONG !!!")
		else:
			file_2.write(" " + hexTobinary(message) + " " + ciphertext + "\n")

	file.close
	file_2.close
	file_input.close

	print ("Finished making test files!")

def generate_test_data_pipeline():

	print ("Started printing test data...")
	print ()

	file_input = open("testfiles/des_test_vectors_pipeline.txt", "r")

	counter = 0

	for counter in range(1, 129):
		print ("reg message" + str(counter) + ";")
		print ("reg expected" + str(counter) + ";")

	counter = 0

	print ("round_keys <= 768'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;")

	for line in file_input:

		counter += 1

		args = line.split()

		master_key = args[0]
		message = args[1]

		ciphertext = DES_encrypt(message, master_key)

		print ("message" + str(counter) + " <= 64'b" + hexTobinary(message) + ";")
		print ("expected" + str(counter) + " <= 64'b" + ciphertext + ";")

	file_input.close

	print ()
	print ("Finished making test files!")

def generate_tests_pipeline():

	print ("Started making test file...")
	print ()

	file_input = open("testfiles/des_test_vectors_pipeline.txt", "r")
	file_1 = open("testfiles/des_tests_pipeline_input.txt", "w")
	file_2 = open("testfiles/des_tests_pipeline_expected.txt", "w")

	file_2.write(" " + "0000000000000000000000000000000000000000000000000000000000000000" + "\n")
	file_2.write(" " + "0000000000000000000000000000000000000000000000000000000000000000" + "\n")
	file_2.write(" " + "0000000000000000000000000000000000000000000000000000000000000000" + "\n")
	file_2.write(" " + "0000000000000000000000000000000000000000000000000000000000000000" + "\n")
	file_2.write(" " + "0000000000000000000000000000000000000000000000000000000000000000" + "\n")
	file_2.write(" " + "0000000000000000000000000000000000000000000000000000000000000000" + "\n")
	file_2.write(" " + "0000000000000000000000000000000000000000000000000000000000000000" + "\n")
	file_2.write(" " + "0000000000000000000000000000000000000000000000000000000000000000" + "\n")
	file_2.write(" " + "0000000000000000000000000000000000000000000000000000000000000000" + "\n")
	file_2.write(" " + "0000000000000000000000000000000000000000000000000000000000000000" + "\n")
	file_2.write(" " + "0000000000000000000000000000000000000000000000000000000000000000" + "\n")
	file_2.write(" " + "0000000000000000000000000000000000000000000000000000000000000000" + "\n")
	file_2.write(" " + "0000000000000000000000000000000000000000000000000000000000000000" + "\n")
	file_2.write(" " + "0000000000000000000000000000000000000000000000000000000000000000" + "\n")
	file_2.write(" " + "0000000000000000000000000000000000000000000000000000000000000000" + "\n")
	file_2.write(" " + "0000000000000000000000000000000000000000000000000000000000000000" + "\n")
	file_2.write(" " + "0000000000000000000000000000000000000000000000000000000000000000" + "\n")
	file_2.write(" " + "0000000000000000000000000000000000000000000000000000000000000000" + "\n")
	file_2.write(" " + "0000000000000000000000000000000000000000000000000000000000000000" + "\n")

	for line in file_input:

		args = line.split()

		master_key = args[0]
		message = args[1]

		ciphertext = DES_encrypt(message, master_key)

		file_1.write(" " + hexTobinary(message) + "\n")
		file_2.write(" " + ciphertext + "\n")

	file_1.write(" " + "0000000000000000000000000000000000000000000000000000000000000000" + "\n")
	file_1.write(" " + "0000000000000000000000000000000000000000000000000000000000000000" + "\n")
	file_1.write(" " + "0000000000000000000000000000000000000000000000000000000000000000" + "\n")
	file_1.write(" " + "0000000000000000000000000000000000000000000000000000000000000000" + "\n")
	file_1.write(" " + "0000000000000000000000000000000000000000000000000000000000000000" + "\n")
	file_1.write(" " + "0000000000000000000000000000000000000000000000000000000000000000" + "\n")
	file_1.write(" " + "0000000000000000000000000000000000000000000000000000000000000000" + "\n")
	file_1.write(" " + "0000000000000000000000000000000000000000000000000000000000000000" + "\n")
	file_1.write(" " + "0000000000000000000000000000000000000000000000000000000000000000" + "\n")
	file_1.write(" " + "0000000000000000000000000000000000000000000000000000000000000000" + "\n")
	file_1.write(" " + "0000000000000000000000000000000000000000000000000000000000000000" + "\n")
	file_1.write(" " + "0000000000000000000000000000000000000000000000000000000000000000" + "\n")
	file_1.write(" " + "0000000000000000000000000000000000000000000000000000000000000000" + "\n")
	file_1.write(" " + "0000000000000000000000000000000000000000000000000000000000000000" + "\n")
	file_1.write(" " + "0000000000000000000000000000000000000000000000000000000000000000" + "\n")
	file_1.write(" " + "0000000000000000000000000000000000000000000000000000000000000000" + "\n")
	file_1.write(" " + "0000000000000000000000000000000000000000000000000000000000000000" + "\n")
	file_1.write(" " + "0000000000000000000000000000000000000000000000000000000000000000" + "\n")
	file_1.write(" " + "0000000000000000000000000000000000000000000000000000000000000000" + "\n")

	file_input.close
	file_1.close
	file_2.close

	print ()
	print ("Finished making test files!")

def generate_test_data_hw():

	print ("Started printing test data...")
	print ()

	file_input = open("testfiles/des_tests_hw.txt", "r")

	# All zero key
	# 0101010101010101

	counter = 0

	print("region set to zero for tests")
	print ("round_keys <= 768'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;")

	for line in file_input:

		args = line.split()

		master_key = args[0]
		message = args[1]

		ciphertext = DES_encrypt(message, master_key)

		message_bits = hexTobinary(message)
		cipher_bits = hexTobinary(ciphertext)

		counter += int(message_bits[len(message_bits) - 1], 2) ^ int(cipher_bits[len(cipher_bits) - 1], 2)

		print ("message: "  + message)
		print ("ciphertext: " + hex(int(ciphertext, 2)))
		print ("counter: " + hex(counter))

	file_input.close

	print ()
	print ("Finished making test files!")
	

def reduce_xor(op):

    if len(op) > 2:
        return int(op[0], 2) ^ reduce_xor(op[1:])
    else:
        return int(op[0], 2) ^ int(op[1], 2)


def main():

	#generate_test_files_NIST()
	#generate_test_data_pipeline()
	#generate_tests_pipeline()
	#generate_test_data_hw()
	
	# All zero key
	# 0101010101010101
	
	master_key = "0101010101010101"
	
	mask_i = int('2104008000000000', 16)
	mask_o = int('0000000021040080', 16)
	
	message = '0149151654114612'
	ciphertext = DES_encrypt_reduced(message, master_key)

	message_bits = hexTobinary(message)
	cipher_bits = hexTobinary(hex(int(ciphertext, 2)))

	# Does this work?
	counter += int(message_bits[len(message_bits) - 1], 2) ^ int(cipher_bits[len(cipher_bits) - 1], 2)
	
	print('C_hex: ' + hex(int(ciphertext, 2)))
	print('C_bin: ' + ciphertext)
	print('Counter: ' + counter)

	# Other stuff to try:
	# - The test vectors from NIST on the full implementation
	# - Smaller masks and extend to verify the working
	# - 8 encryptions
	# - See if the HW does the same
	# - See if we can solve less than 8 encryption case 
	# (active signal goes up when message becomes valid and only goes down when cipher text goes up, take this for shifting as well)
	# - Write a test for the LFSR and try to verify the working of this

if __name__ == '__main__':
    main()
