
def lfsr(seed, taps, file):

    for i in range(1,taps):
        feedback_bit = seed[0] ^ seed[1] ^ seed[3] ^ seed[4]

        if feedback_bit == 1:
            feedback_bit = 0
        else:
            feedback_bit = 1

        for j in range(0, 63):
            seed[j] = seed[j+1]

        seed[63] = feedback_bit

        seed_string = ""

        #for j in seed:
        #    seed_string += str(j)

	    seed_string = ''.join([str(j) for j in seed])

        file.write(seed_string + "\n")
        


      

def generate_tests_lfsr(taps):

    print ("Started generating test data...")
    print ("Test for duplicates in the file: tr 'A-Z' 'a-z' < ./testfiles/lfsr_tests.txt | sort | uniq -d")
    print 

    file_output = open("testfiles/lfsr_tests.txt", "w")

    # List represenating all 64 bit values in our seed
    # first element is bit 64 in the verilog design, will thus shift to the left
    seed = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

    #for i in seed:
    #    seed_string += str(i)
    seed_string = ''.join([str(j) for j in seed])

    print ("seed: " + seed_string)

    lfsr(seed, taps, file_output)

    ####

    file_output.close

    print 
    print ("Finished making test files!")


def main():

    generate_tests_lfsr(1000000)
    

if __name__ == '__main__':
    main()
