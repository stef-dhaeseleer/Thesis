#include "interface.h"

#include "xil_cache.h"
#include "xil_printf.h"


void interface_init() {
    axi_port = (unsigned int *)0x43C00000;
}

void set_cmd(unsigned int cmd) {
    // Set register 0 of the AXI to the specified command
    axi_port[0] = cmd;
}

void set_region(uint16_t region) {
    // Set register 1 of the AXI to the specified region
    axi_port[1] = region;
}

void advance_test() {
    // Set register 2 of the AXI to advance the test, the AXi resets this to zero itself
    axi_port[2] = 1;
}

void print_reg_contents() {
	xil_printf("0: %x \r\n", axi_port[0]);
	xil_printf("1: %x \r\n", axi_port[1]);
	xil_printf("2: %x \r\n", axi_port[2]);
	xil_printf("3: %x \r\n", axi_port[3]);
	xil_printf("4: %x \r\n", axi_port[4]);
	xil_printf("5: %x \r\n", axi_port[5]);
	xil_printf("6: %x \r\n", axi_port[6]);
	xil_printf("7: %x \r\n", axi_port[7]);
	xil_printf("8: %x \r\n", axi_port[8]);
	xil_printf("9: %x \r\n", axi_port[9]);

	xil_printf("\r\n");
}

void wait_for_cmd_read() {
    // Check register 3 of the AXI for the command read signal
    while(axi_port[3]==0)
    {
    	//print_reg_contents();
    	//sleep(5);
    }
}

void wait_for_test_res_ready() {
    // Check register 4 of the AXI for the test result ready signal
    while(axi_port[4]==0)
    {
    	//print_reg_contents();
		//sleep(5);
    }
}

void wait_for_done() {
    // Check register 9 of the AXI for the done signal
    while(axi_port[9]==0)
    {}
}
