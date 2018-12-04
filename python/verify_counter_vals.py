import math

def main():

    N = 27              # Number of region bits
    
	count = 200	        # Counter value
	exp = 2**(64-N)	    # Nb of encryptions = 2**(64-N)

	bias_expected = 2**(-13.5)      # expected bias for 8 round test


    bias = (count/exp) - 0.5

	print 
	print ("################################################################################")
	print 

	print ()
	print

if __name__ == '__main__':
    main()

