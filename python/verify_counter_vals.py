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


def get_mean_std():

    file_res = open("counter_results/bias_results.txt", "r")

    bias = []

    for line in file_res:
        if(len(line.split()) != 0):
            if (line.split()[0] == "Calculated"):
                bias.append(float(line.split()[3]))

    mean = 0
    std = 0

    for i in range(0, len(bias)):
        mean += bias[i]

    mean = mean/len(bias)

    for i in range(0, len(bias)):
        std += (bias[i] - mean)**2

    std = std/len(bias)
    std = math.sqrt(std)

    print 
    print ("################################################################################")
    print ("Mean        : " + str(mean))
    print ("Mean log 2  : " + str(math.log(mean, 2)))
    print ("STD         : " + str(std))
    print ("STD  log 2  : " + str(math.log(std, 2)))
    print ("Nb elements : " + str(len(bias)))    


def all_verify():

    file = open("counter_results/results.txt", "r")
    file_key = open("counter_results/result_keys.txt", "r")

    keys  = []

    for line in file_key:
        keys.append(line)    

    file_res = open("counter_results/bias_results.txt", "a")

    N = 32                     # Number of region bits
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

        file_res.write("Region          : " + region + "\n")
        file_res.write("Expected bias   : " + str(bias_expected) + "\n")
        file_res.write("Calculated bias : " + str(bias) + "\n")
        file_res.write("Difference      : " + str(diff) + "\n")

        file_res.write("Key             : " + keys[i%32] + "\n")   # Remainder for if multiple runs with the same keys
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

    get_mean_std()

if __name__ == '__main__':
    main()

