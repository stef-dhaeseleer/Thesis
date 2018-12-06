import math

def one_verify():

    N = 32                      # Number of region bits

    count = 0x000000007ffd6b26  # Counter value
    exp = 2**(64-N)             # Nb of encryptions = 2**(64-N)

    bias_expected = 2**(-13.5)      # expected bias for 8 round test

    bias = abs((count/float(exp)) - 0.5)

    diff = abs(bias - bias_expected)

    print 
    print ("################################################################################")
    print ("Expected bias   : " + str(bias_expected))
    print ("Calculated bias : " + str(bias))
    print ("Difference      : " + str(diff))


def all_verify():

    file = open("testfiles/results.txt", "r")
    file_key = open("testfiles/result_keys.txt", "r")

    keys  = []

    for line in file_key:
        keys.append(line)    

    file_res = open("testfiles/bias_results.txt", "aw")

    N = 27                      # Number of region bits
    exp = 2**(64-N)            # Nb of encryptions = 2**(64-N)
    bias_expected = 2**(-13.5)      # expected bias for 8 round test

    total_count = 0
    total_lines = 0
    
    file.readline()   # skip the header file

    i = 0

    for line in file:
        region = line.split()[0]
        count = line.split()[2]
        count = int(count, 16)
        bias = abs((count/float(exp)) - 0.5)
        diff = abs(bias - bias_expected)

        total_count += count
        total_lines += 1

        print 
        print ("################################################################################")
        print ("Expected bias   : " + str(bias_expected))
        print ("Calculated bias : " + str(bias))
        print ("Difference      : " + str(diff))

        file_res.write(region + "\n")
        file_res.write(str(bias_expected) + "\n")
        file_res.write(str(bias) + "\n")
        file_res.write(str(diff) + "\n")

        file_res.write(keys[i%32] + "\n")   # Remainder for if multiple runs with the same keys
        file_res.write("\n")

        i += 1

    # Now process the complete result as well

    bias = abs((total_count/float(exp*total_lines)) - 0.5)
    diff = abs(bias - bias_expected)

    print 
    print ("################################################################################")
    print ("FINAL RESULT OVER ALL COUNTERS")
    print ("Expected bias   : " + str(bias_expected))
    print ("Calculated bias : " + str(bias))
    print ("Difference      : " + str(diff))

def main():

    all_verify()

if __name__ == '__main__':
    main()

