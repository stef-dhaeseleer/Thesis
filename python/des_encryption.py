# REFERENCE
# This file is used to generate test vectors and verify the working of our DES Verilog engine
# https://medium.com/@urwithajit9/how-to-teach-des-using-python-the-easy-way-part-1-des-subkey-generation-bb5a853ef9b0
# https://medium.com/@urwithajit9/how-to-teach-des-using-python-the-easy-way-part-2-round-function-f-285dd3aef34d
# https://medium.com/@urwithajit9/how-to-teach-des-using-python-the-easy-way-part-3-des-encryption-4394a935effc

from des_functions import *
from des_keygen import *

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

	print ("round_keys <= 768'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000")

	for line in file_input:

		counter += 1

		args = line.split()

		master_key = args[0]
		message = args[1]

		ciphertext = DES_encrypt(message, master_key)

		print ("message" + str(counter) + " <= 64'b" + hexTobinary(message))
		print ("expected" + str(counter) + " <= 64'b" + ciphertext)

	file_input.close

	print ()
	print ("Finished making test files!")


def main():

	#generate_test_files_NIST()
	generate_test_data_pipeline()
	

if __name__ == '__main__':
    main()