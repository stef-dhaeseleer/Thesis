# REFERENCE
# This file is used to generate test vectors and verify the working of our DES Verilog engine
# https://medium.com/@urwithajit9/how-to-teach-des-using-python-the-easy-way-part-1-des-subkey-generation-bb5a853ef9b0
# https://medium.com/@urwithajit9/how-to-teach-des-using-python-the-easy-way-part-2-round-function-f-285dd3aef34d
# https://medium.com/@urwithajit9/how-to-teach-des-using-python-the-easy-way-part-3-des-encryption-4394a935effc

import textwrap
from des_keygen import *

EXPANSION_TABLE = [32, 1, 2, 3, 4, 5, 4, 5, 6, 7, 8, 9, 8, 9, 10, 11, 12, 13, 12, 13, 14, 15, 16, 17, 16, 17, 18, 19, 20, 21, 20, 21, 22, 23, 24, 25, 24, 25, 26, 27, 28, 29, 28, 29, 30, 31, 32, 1]

PERMUTATION_TABLE = [16, 7, 20, 21, 29, 12, 28, 17, 1, 15, 23, 26, 5, 18, 31, 10, 2, 8, 24, 14, 32, 27, 3, 9, 19, 13, 30, 6, 22, 11, 4, 25]

INITIAL_PERMUTATION_TABLE = ['58 ', '50 ', '42 ', '34 ', '26 ', '18 ', '10 ', '2',
			 '60 ', '52 ', '44 ', '36 ', '28 ', '20 ', '12 ', '4',
			 '62 ', '54 ', '46 ', '38 ', '30 ', '22 ', '14 ', '6', 
			'64 ', '56 ', '48 ', '40 ', '32 ', '24 ', '16 ', '8', 
			'57 ', '49 ', '41 ', '33 ', '25 ', '17 ', '9 ', '1',
			 '59 ', '51 ', '43 ', '35 ', '27 ', '19 ', '11 ', '3',
			 '61 ', '53 ', '45 ', '37 ', '29 ', '21 ', '13 ', '5',
			 '63 ', '55 ', '47 ', '39 ', '31 ', '23 ', '15 ', '7']

INVERSE_PERMUTATION_TABLE = ['40 ', '8 ', '48 ', '16 ', '56 ', '24 ', '64 ', '32',
			     '39 ', '7 ', '47 ', '15 ', '55 ', '23 ', '63 ', '31',
			     '38 ', '6 ', '46 ', '14 ',  '54 ', '22 ', '62 ', '30',
			     '37 ', '5 ', '45 ', '13 ', '53 ', '21 ', '61 ', '29',
			     '36 ', '4 ', '44 ', '12 ', '52 ', '20 ', '60 ', '28',
			     '35 ', '3 ', '43 ', '11 ', '51 ', '19 ', '59 ', '27', 
			     '34 ', '2 ', '42 ', '10 ', '50 ', '18 ', '58 ', '26',
			     '33 ', '1 ', '41 ', '9 ', '49 ', '17 ', '57 ', '25']


SBOX = [
# Box-1
[
[14,4,13,1,2,15,11,8,3,10,6,12,5,9,0,7],
[0,15,7,4,14,2,13,1,10,6,12,11,9,5,3,8],
[4,1,14,8,13,6,2,11,15,12,9,7,3,10,5,0],
[15,12,8,2,4,9,1,7,5,11,3,14,10,0,6,13]
],
# Box-2

[
[15,1,8,14,6,11,3,4,9,7,2,13,12,0,5,10],
[3,13,4,7,15,2,8,14,12,0,1,10,6,9,11,5],
[0,14,7,11,10,4,13,1,5,8,12,6,9,3,2,15],
[13,8,10,1,3,15,4,2,11,6,7,12,0,5,14,9]
],

# Box-3

[
[10,0,9,14,6,3,15,5,1,13,12,7,11,4,2,8],
[13,7,0,9,3,4,6,10,2,8,5,14,12,11,15,1],
[13,6,4,9,8,15,3,0,11,1,2,12,5,10,14,7],
[1,10,13,0,6,9,8,7,4,15,14,3,11,5,2,12]

],

# Box-4
[
[7,13,14,3,0,6,9,10,1,2,8,5,11,12,4,15],
[13,8,11,5,6,15,0,3,4,7,2,12,1,10,14,9],
[10,6,9,0,12,11,7,13,15,1,3,14,5,2,8,4],
[3,15,0,6,10,1,13,8,9,4,5,11,12,7,2,14]
],

# Box-5
[
[2,12,4,1,7,10,11,6,8,5,3,15,13,0,14,9],
[14,11,2,12,4,7,13,1,5,0,15,10,3,9,8,6],
[4,2,1,11,10,13,7,8,15,9,12,5,6,3,0,14],
[11,8,12,7,1,14,2,13,6,15,0,9,10,4,5,3]
],
# Box-6

[
[12,1,10,15,9,2,6,8,0,13,3,4,14,7,5,11],
[10,15,4,2,7,12,9,5,6,1,13,14,0,11,3,8],
[9,14,15,5,2,8,12,3,7,0,4,10,1,13,11,6],
[4,3,2,12,9,5,15,10,11,14,1,7,6,0,8,13]

],
# Box-7
[
[4,11,2,14,15,0,8,13,3,12,9,7,5,10,6,1],
[13,0,11,7,4,9,1,10,14,3,5,12,2,15,8,6],
[1,4,11,13,12,3,7,14,10,15,6,8,0,5,9,2],
[6,11,13,8,1,4,10,7,9,5,0,15,14,2,3,12]
],
# Box-8

[
[13,2,8,4,6,15,11,1,10,9,3,14,5,0,12,7],
[1,15,13,8,10,3,7,4,12,5,6,11,0,14,9,2],
[7,11,4,1,9,12,14,2,0,6,10,13,15,3,5,8],
[2,1,14,7,4,10,8,13,15,12,9,0,3,5,6,11]
]

]

HEX_to_Binary = {'0':'0000',
		 '1':'0001',
		 '2':'0010',
		 '3':'0011',
		 '4':'0100',
		 '5':'0101',
		 '6':'0110',
		 '7':'0111',
		 '8':'1000',
		 '9':'1001',
		 'A':'1010',
		 'B':'1011',
		 'C':'1100',
		 'D':'1101',
		 'E':'1110',
		 'F':'1111',
		}

def apply_Expansion(expansion_table, input):
	
	output = ""

	for i in expansion_table:
		output += input[i-1]	# Minus one needed to map from elements in table to python indices (start at 0 not one)

	return output

def XOR(input_1, input_2):
	
	xor_result = ""

	for i in range(len(input_1)):

		if input_1[i] == input_2[i]: 
			xor_result += '0'
		else:
			xor_result += '1'

	return xor_result

def split_in_6bits(XOR_48bits):

	list_of_6bits = textwrap.wrap(XOR_48bits,6)

	return list_of_6bits

def get_first_and_last_bit(bits6):
	
	twobits = bits6[0] + bits6[-1] 

	return twobits

def get_middle_four_bit(bits6):
	
	fourbits = bits6[1:5] 

	return fourbits

def binary_to_decimal(binarybits):
	
	decimal = int(binarybits,2)

	return decimal

def decimal_to_binary(decimal):
	
	binary4bits = bin(decimal)[2:].zfill(4)

	return binary4bits

def sbox_lookup(sboxcount, first_last, middle4):
	
	d_first_last = binary_to_decimal(first_last)
	d_middle = binary_to_decimal(middle4)
	
	sbox_value = SBOX[sboxcount][d_first_last][d_middle]

	return decimal_to_binary(sbox_value)

def apply_Permutation(permutation_table, sbox_32bits):
	
	final_32bits = ""

	for index in permutation_table:
		final_32bits += sbox_32bits[index-1]

	return final_32bits

def functionF(pre32bits, key48bits):	
	
	result = ""

	expanded_left_half = apply_Expansion(EXPANSION_TABLE,pre32bits)
	xor_value = XOR(expanded_left_half,key48bits)
	bits6list = split_in_6bits(xor_value)

	for sboxcount, bits6 in enumerate(bits6list):
		first_last = get_first_and_last_bit(bits6)
		middle4 = get_middle_four_bit(bits6)
		sboxvalue = sbox_lookup(sboxcount,first_last,middle4)
		result += sboxvalue

	final32bits = apply_Permutation(PERMUTATION_TABLE,result)	

	return final32bits

def hexDigit_to_binary_bits(hex_digit):

	binary_4bits = HEX_to_Binary[hex_digit]

	return binary_4bits

def hexString_to_binary_bits1(hex_string):

	binary_bits = ""

	for hex_digit in hex_string:
		binary_bits += hexDigit_to_binary_bits(hex_digit)

	return binary_bits

def hexString_to_binary_bits2(hexdigits):

	binarydigits = ""

	for hexdigit in hexdigits:
		binarydigits += bin(int(hexdigit,16))[2:].zfill(4)

	return binarydigits

def hexTobinary(hexdigits):

	binarydigits = ""

	for hexdigit in hexdigits:
		binarydigits += bin(int(hexdigit,16))[2:].zfill(4)

	return binarydigits

def apply_initial_p(P_TABLE, PLAINTEXT):

	permutated_M = ""

	for index in P_TABLE:
		permutated_M += PLAINTEXT[int(index)-1]

	return permutated_M

def spliHalf(binarybits):

	return binarybits[:32],binarybits[32:]


