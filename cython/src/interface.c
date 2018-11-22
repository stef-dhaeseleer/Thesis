#include "interface.h"

void interface_init() {
    axi_port_0 = (unsigned int *)0x43C00000;
    axi_port_1 = (unsigned int *)0x43C10000;
}

void set_cmd(unsigned int cmd, unsigned int * port) {
    // Set register 0 of the AXI to the specified command
    //unsigned int * port_val = (unsigned int *)0x43C00000;
    port[0] = cmd;
}

void set_region(uint16_t region, unsigned int * port) {
    // Set register 1 of the AXI to the specified region
    //unsigned int * port_val = (unsigned int *)0x43C00000;
    printf("test: %x \r\n", port);
    port[1] = region;
}

void advance_test(unsigned int * port) {
    // Set register 2 of the AXI to advance the test, the AXi resets this to zero itself
    port[2] = 1;
}

void print_reg_contents(unsigned int * port) {
    //unsigned int * port_val = (unsigned int *)0x43C00000;

	printf("CMD REG 0               : %x \r\n", port[0]);
	printf("REGION REG 1            : %x \r\n", port[1]);
	printf("TEST ADVANCE REG 2      : %x \r\n", port[2]);
	printf("CMD READ REG 3          : %x \r\n", port[3]);
	printf("TEST RESULT READY REG 4 : %x \r\n", port[4]);
	printf("UPPER CIPHERTEXT REG 5  : %x \r\n", port[5]);
	printf("LOWER CIPHER TEXT REG 6 : %x \r\n", port[6]);
	printf("UPPER COUNTER REG 7     : %x \r\n", port[7]);
	printf("LOWER COUNTER REG 8     : %x \r\n", port[8]);
	printf("DONE REG 9              : %x \r\n", port[9]);

	printf("\r\n");
}

void wait_for_cmd_read(unsigned int * port) {
    // Check register 3 of the AXI for the command read signal
    while(port[3]==0)
    {
    	//print_reg_contents(port);
    	//sleep(5);
    }
	//sleep(1);
}

void wait_for_test_res_ready(unsigned int * port) {
    // Check register 4 of the AXI for the test result ready signal
    while(port[4]==0)
    {
    	//print_reg_contents(port);
		//sleep(5);
    }
}

void wait_for_done(unsigned int * port) {
    // Check register 9 of the AXI for the done signal
    while(port[9]==0)
    {

    }
}

uint32_t get_done(unsigned int * port) {
    return port[9];
}

uint32_t get_region(unsigned int * port) {
    return port[1];
}

uint32_t get_counter_lower(unsigned int * port) {
    return port[8];
}

uint32_t get_counter_upper(unsigned int * port) {
    return port[7];
}
