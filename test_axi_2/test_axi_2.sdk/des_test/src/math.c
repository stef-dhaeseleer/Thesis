
// Calculates res = a + b.
// a and b represent large integers stored in uint32_t arrays
// a and b are arrays of size elements, res has size+1 elements
void mp_add(uint32_t *a, uint32_t *b, uint32_t *res, uint32_t size) {
    
    uint32_t c = 0;
    uint32_t i;
    uint64_t temp;

    for (i = 0; i < size; i++){
        temp = ( (uint64_t) a[i] + (uint64_t) b[i] + (uint64_t) c);
        if (temp < 4294967296){
            c = 0;
        }
        else {
            c = 1;
        }
        res[i] = (uint32_t) (temp % 4294967296);
    }
    res[size] = c;
}

void arrayprint(uint32_t *array, uint32_t size){

    xil_printf("=========================================================\r\n");
    xil_printf("Result: 0x");
    int i = size - 1;

    while (array[i] == 0)
        i -= 1;
    if (i >= 0) {
        xil_printf("%x", array[i]);
        i -= 1;
        for ( ; i >= 0; i--){
            xil_printf("%08x", array[i]);
        }
        xil_printf("\r\n");
    }
    else {
        xil_printf("%x", 0);
        xil_printf("\r\n");
    }
}