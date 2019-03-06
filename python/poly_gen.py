def gen_poly_list():

    file_poly = open("testfiles/poly.txt", "r")

    poly_list_str = "["

    for line in file_poly:

        # Format:
        #int('800000000000000D', 16)

        poly = line.split()[0]
        poly_list_str += ", int(\'" + poly + "\', 16)"

    poly_list_str += "]"
        
    file_poly.close()

    print

    print (poly_list_str)

    print  
         

def main():
    
    gen_poly_list()

if __name__ == '__main__':
    main()

