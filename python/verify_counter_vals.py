import math

def main():

    N = 27              # Number of region bits
    
	count = 200	        # Counter value
	exp = 2**(64-N)	    # Nb of encryptions = 2**(64-N)

	N = 22

	seconds_per_day = 24*60*60
	
	encrypt_per_day = nb_blocks * clock_freq * 10**6 * seconds_per_day
	two_exp = math.log(encrypt_per_day, 2)

	encrypt_per_block_day = clock_freq * 10**6 * seconds_per_day
	two_exp_block = math.log(encrypt_per_block_day, 2)

	encryptions_per_block = 2**(64-N)

	seconds_per_block = encryptions_per_block / float(clock_freq * 10**6)

	hours_per_block = seconds_per_block / float(60*60)

	print 
	print ("################################################################################")
	print 

	print ("Clock frequency            : " + str(clock_freq))
	print ("DES cores                  : " + str(nb_blocks))
	print ("Encryptions per day (block): " + str(encrypt_per_block_day))
	print ("Encryptions 2 exp          : " + str(two_exp_block))
	print ("Encryptions per day (total): " + str(encrypt_per_day))
	print ("Encryptions 2 exp          : " + str(two_exp))
	print

	print ("Time for core complete     : " + str(hours_per_block) + " hours for " + str(N) + " bit region")

if __name__ == '__main__':
    main()
