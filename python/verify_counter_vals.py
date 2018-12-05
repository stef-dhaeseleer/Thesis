import math

def one_verify():

    N = 27                      # Number of region bits

    count = 0x0000000fff996560 # Counter value
    exp = 2**(64-N)            # Nb of encryptions = 2**(64-N)

    bias_expected = 2**(-13.5)      # expected bias for 8 round test

    bias = abs((count/exp) - 0.5)

    diff = abs(bias - bias_expected)

    print ()
    print ("################################################################################")
    print ("Expected bias   : " + str(bias_expected))
    print ("Calculated bias : " + str(bias))
    print ("Difference      : " + str(diff))
    print ()

    print ()
    print ()

def all_verify():

    file_input = open("testfiles/report.txt", "r")

    N = 27                      # Number of region bits
    exp = 2**(64-N)            # Nb of encryptions = 2**(64-N)
    bias_expected = 2**(-13.5)      # expected bias for 8 round test

    count = 0x0000000fff996560 # Counter value

    bias = abs((count/exp) - 0.5)

    diff = abs(bias - bias_expected)

    print ()
    print ("################################################################################")
    print ("Expected bias   : " + str(bias_expected))
    print ("Calculated bias : " + str(bias))
    print ("Difference      : " + str(diff))
    print ()

    print ()
    print ()

def main():

    one_verify()

if __name__ == '__main__':
    main()

