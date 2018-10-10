
def main():

    counter = 0

    for counter in range(21, 129):
        print("message <= message" + str(counter) + ";")    
        print("nb_tests <= nb_tests + 1;")
        print("nb_correct <= nb_correct + (expected"+ str(counter-19) +" - result == 64'h0);")
        print("#`CLK_PERIOD;")
        print()

    for counter in range(110, 129):
        print("nb_tests <= nb_tests + 1;")
        print("nb_correct <= nb_correct + (expected"+ str(counter) +" - result == 64'h0);")
        print("#`CLK_PERIOD;")
        print()

if __name__ == '__main__':
    main()