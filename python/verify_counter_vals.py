import math

def one_verify():

    N = 44                      # Number of region bits

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
    file_res = open("counter_results/bias_results.txt", "w")
    file_stat = open("counter_results/bias_stats.txt", "w")

    exp = 2**(32)                    # Nb of encryptions per core

    total_count = 0
    total_bias = 0
    total_lines = 0
    
    bias_list = []
    
    file.readline()   # skip the header line

    for line in file:
        poly = line.split()[0]
        count = line.split()[4]
        count = int(count, 16)
        bias = abs((count/float(exp)) - 0.5)

        total_count += count
        total_bias += bias
        total_lines += 1
        
        bias_list.append(bias)

        print 
        print ("################################################################################")
        print ("Calculated bias sample " + str(total_lines) + " : " + str(bias))


        file_res.write("Polynomial      : " + poly + "\n")
        file_res.write("Calculated bias : " + str(bias) + "\n")
        file_res.write("\n")

    # Now process the complete result as well
    bias = abs((total_count/float(exp*total_lines)) - 0.5)
    
    mean = 0
    std = 0
    
    mean = total_bias/total_lines

    for i in range(0, total_lines):
        std += (bias_list[i] - mean)**2

    std = std/total_lines
    std = math.sqrt(std)
    
    file_stat.write("RESULTS FROM EXPERIMENT " + "\n")
    file_stat.write("\n")
    
    file_stat.write("Bias (total count): " + str(bias) + "\n")
    file_stat.write("log2              : " + str(math.log(bias, 2)) + "\n")
    file_stat.write("\n")
    file_stat.write("Mean bias   : " + str(mean) + "\n")
    file_stat.write("Mean log 2  : " + str(math.log(mean, 2)) + "\n")
    file_stat.write("\n")
    file_stat.write("STD         : " + str(std) + "\n")
    file_stat.write("STD  log 2  : " + str(math.log(std, 2)) + "\n")
    file_stat.write("\n")
    file_stat.write("Samples : " + str(total_lines) + "\n")
    file_stat.write("Encryptions per sample (log2) : " + str(math.log(exp, 2)) + "\n")

    print 
    print ("################################################################################")
    print ("FINAL RESULT OVER ALL COUNTERS")

    print ("Bias (total count) : " + str(bias))
    print ("log2               : " + str(math.log(bias, 2)))
    print ("Mean bias   : " + str(mean))
    print ("Mean log 2  : " + str(math.log(mean, 2)))
    print ("STD         : " + str(std))
    print ("STD  log 2  : " + str(math.log(std, 2)))

    print ("Samples : " + str(total_lines))
    print

def main():

    all_verify()

if __name__ == '__main__':
    main()

