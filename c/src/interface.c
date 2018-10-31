#include "interface.h"

#include "xil_cache.h"
#include "xil_printf.h"


void interface_init() {
    // TODO: check this value (1)
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

void wait_for_cmd_read() {
    // Check register 3 of the AXI for the command read signal
    while(axi_port[3]==0)
    {
    	//sleep(1);
    }
}

void wait_for_test_res_ready() {
    // Check register 4 of the AXI for the test result ready signal
    while(axi_port[4]==0)
    {}
}

void wait_for_done() {
    // Check register 9 of the AXI for the done signal
    while(axi_port[9]==0)
    {}
}
