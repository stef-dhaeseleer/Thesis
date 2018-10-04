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

	# Roundfunctions
	for round in range(16):
		newR = XOR(L,functionF(R, roundkeys[round]))
		newL = R

		R = newR	# Switch the parts to initialize the next round
		L = newL

	cipher = apply_initial_p(INVERSE_PERMUTATION_TABLE, R+L)

	return cipher

def main():
    
	master_key = "0101010101010101"
	message = "95F8A5E5DD31D900"

	expected = hexTobinary("8000000000000000")

	print ()
	print ("################################################################################")
	print ()

	ciphertext = DES_encrypt(message, master_key)

	print ("Key: " + master_key)
	print ("Message: " + message)
	print ()
	print ("Ciphertext: " + ciphertext)
	print ("Expected  : " + expected)
	if (expected == ciphertext):
		print("CORRECT")
	else:
		print("NOT CORRECT")

	print ()

if __name__ == '__main__':
    main()