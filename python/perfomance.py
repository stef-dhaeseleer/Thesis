import math

def main():
    
	clock_freq = 210	# Clock frequency in MHz
	nb_blocks = 32		# Number of DES calculation blocks

	seconds_per_day = 24*60*60
	
	encrypt_per_day = nb_blocks * clock_freq * 10**6 * seconds_per_day
	two_exp = math.log(encrypt_per_day, 2)

	print ()
	print ("################################################################################")
	print ()

	print ("Clock frequency     : " + str(clock_freq))
	print ("DES blocks          : " + str(nb_blocks))
	print ("Encryptions per day : " + str(encrypt_per_day))
	print ("Encryptions 2 exp   : " + str(two_exp))

	print ()

if __name__ == '__main__':
    main()

