import math

def main():
    
	clock_freq = 150	# Clock frequency in MHz
	nb_blocks = 128		# Number of DES calculation blocks

	N = 13

	seconds_per_day = 24*60*60
	
	encrypt_per_day = nb_blocks * clock_freq * 10**6 * seconds_per_day
	two_exp = math.log(encrypt_per_day, 2)
    
	encrypt_per_block_day = clock_freq * 10**6 * seconds_per_day
	two_exp_block = math.log(encrypt_per_block_day, 2)

	encrypt_per_block_sec = clock_freq * 10**6
	two_exp_block_sec = math.log(encrypt_per_block_sec, 2)

	encrypt_per_run = 2**(64-N)
	two_exp_run = math.log(encrypt_per_run, 2)

	encryptions_per_block = 2**(64-N)

	seconds_per_block = encryptions_per_block / float(clock_freq * 10**6)

	hours_per_block = seconds_per_block / float(60*60)
	hours_for_board = hours_per_block / float(nb_blocks)

	print 
	print ("################################################################################")
	print 

	print ("Clock frequency            : " + str(clock_freq))
	print ("DES cores                  : " + str(nb_blocks))
	print ("Encryptions per sec (block): " + str(encrypt_per_block_sec))
	print ("Encryptions 2 exp          : " + str(two_exp_block_sec))
	print ("Encryptions per day (block): " + str(encrypt_per_block_day))
	print ("Encryptions 2 exp          : " + str(two_exp_block))
	print ("Encryptions per run (block): " + str(encrypt_per_run))
	print ("Encryptions 2 exp          : " + str(two_exp_run))
	print ("Encryptions per day (total): " + str(encrypt_per_day))
	print ("Encryptions 2 exp          : " + str(two_exp))
	print

	print ("Time for core complete     : " + str(hours_per_block) + " hours for " + str(N) + " bit region")
	print ("Time for board complete    : " + str(hours_for_board) + " hours for " + str(N) + " bit region")
if __name__ == '__main__':
    main()

