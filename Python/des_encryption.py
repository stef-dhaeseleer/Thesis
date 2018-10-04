# REFERENCE
# This file is used to generate test vectors and verify the working of our DES Verilog engine
# https://medium.com/@urwithajit9/how-to-teach-des-using-python-the-easy-way-part-1-des-subkey-generation-bb5a853ef9b0
# https://medium.com/@urwithajit9/how-to-teach-des-using-python-the-easy-way-part-2-round-function-f-285dd3aef34d
# https://medium.com/@urwithajit9/how-to-teach-des-using-python-the-easy-way-part-3-des-encryption-4394a935effc

from des_functions import *
from des_keygen import *

def DES_encrypt(message,key):

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

	print ("Round keys: ")
	for i in range(16):
		print (roundkeys[i])

	print()
	print()

	print ("Initial L and R: ")
	print (L + " and " + R)

	print ()

	print ("Round values for L and R: ")

	# Roundfunctions
	for round in range(16):

		newR = XOR(L,functionF(R, roundkeys[round]))
		newL = R

		R = newR	# Switch the parts to initialize the next round
		L = newL

		print ("Round " + str(round) + " output: ")
		print (L + " and " + R)
		print ()

	cipher = apply_initial_p(INVERSE_PERMUTATION_TABLE, R+L)

	return cipher

def main():
    
	master_key = "0101010101010101"
	message = "95F8A5E5DD31D900"

	expected = "0x8000000000000000"

	print ()
	print ("################################################################################")
	print ()

	ciphertext = DES_encrypt(message, master_key)

	print ()
	print ()
	print ()
	print ("Key: " + master_key)
	print ("Message: " + message)
	print ()
	print ("Ciphertext: " + hex(int(ciphertext, 2)))
	print ("Expected  : " + expected)
	if (expected == hex(int(ciphertext, 2))):
		print("CORRECT")
	else:
		print("NOT CORRECT")

	print ()

if __name__ == '__main__':
    main()