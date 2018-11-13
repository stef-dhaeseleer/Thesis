
#include "hw.h"

// 0: CMD REG
// 1: REGION REG
// 2: TEST_ADVANCE REG
// ***************************
// 3: CMD_READ REG
// 4: TEST_RESULT_READY REG
// 5: UPPER CIPHERTEXT REG
// 6: LOWER CIPHERTEXT REG
// 7: UPPER COUNTER REG
// 8: LOWER COUNTER REG
// 9: DONE REG

void test_hw(unsigned int * port){

    uint32_t test[2] = {0};
    uint32_t res[2] = {0};

    uint32_t nb_tests = 0;
	uint32_t nb_correct = 0;

    xil_printf("Testing the platform... \r\n");
    xil_printf("\r\n");

    // First set the region to be used to all zeros
    uint32_t region = 0x00000000;
    set_region(region, port);
    xil_printf("Selected region: %08x \r\n", region);

    set_cmd(CMD_READ_REGION, port);
    xil_printf("CMD sent to HW \r\n");
    wait_for_cmd_read(port);

    // Start the DES engine in test mode
    set_cmd(CMD_TEST_MODE, port);
    xil_printf("Starting test mode... \r\n");
    wait_for_cmd_read(port);

    // Wait until the first ciphertext result is ready
    wait_for_test_res_ready(port);

    test[1] = 0x8ca64de9;
    test[0] = 0xc1b123a7;

    res[1] = port[5];
	res[0] = port[6];

	nb_tests += 1;
	nb_correct += compare(test, res, 2);

    xil_printf("Test result: \r\n");
    xil_printf("Message   : %08x%08x \r\n", region, 0x00000000);
    xil_printf("Ciphertext: %08x%08x \r\n", res[1], res[0]);
    xil_printf("Expected  : %08x%08x \r\n", test[1], test[0]);
    xil_printf("\r\n");

    //***********************************************************************
	advance_test(port);
	wait_for_test_res_ready(port);

	test[1] = 0x166b40b4;
	test[0] = 0x4aba4bd6;

	res[1] = port[5];
	res[0] = port[6];

	nb_tests += 1;
	nb_correct += compare(test, res, 2);

	xil_printf("Test result: \r\n");
	xil_printf("Message   : %08x%08x \r\n", region, 0x00000001);
	xil_printf("Ciphertext: %08x%08x \r\n", res[1], res[0]);
	xil_printf("Expected  : %08x%08x \r\n", test[1], test[0]);
	xil_printf("\r\n");

    //***********************************************************************
    advance_test(port);
    wait_for_test_res_ready(port);

    test[1] = 0x06e7ea22;
    test[0] = 0xce92708f;

    res[1] = port[5];
	res[0] = port[6];

	nb_tests += 1;
	nb_correct += compare(test, res, 2);

    xil_printf("Test result: \r\n");
    xil_printf("Message   : %08x%08x \r\n", region, 0x00000002);
    xil_printf("Ciphertext: %08x%08x \r\n", res[1], res[0]);
    xil_printf("Expected  : %08x%08x \r\n", test[1], test[0]);
    xil_printf("\r\n");

    //***********************************************************************
    advance_test(port);
    wait_for_test_res_ready(port);

    test[1] = 0x4eb190c9;
    test[0] = 0xa2fa169c;

    res[1] = port[5];
	res[0] = port[6];

	nb_tests += 1;
	nb_correct += compare(test, res, 2);

    xil_printf("Test result: \r\n");
    xil_printf("Message   : %08x%08x \r\n", region, 0x00000003);
    xil_printf("Ciphertext: %08x%08x \r\n", res[1], res[0]);
    xil_printf("Expected  : %08x%08x \r\n", test[1], test[0]);
    xil_printf("\r\n");



    xil_printf("Testing completed! \r\n");
    xil_printf("Result: %x/%x correct! \r\n", nb_correct, nb_tests);
    xil_printf("Counter: %08x%08x, expected: %08x%08x \r\n", port[7], port[8], 0, 4);
    xil_printf("\r\n");
}

void start_hw(uint16_t region, unsigned int * port) {
    xil_printf("Starting the HW... \r\n");
    xil_printf("\r\n");

    // First set the region to be used to all zeros
    set_region(region, port);
    set_cmd(CMD_READ_REGION, port);
    wait_for_cmd_read(port);

    xil_printf("Selected region: %08x \r\n", region);
    xil_printf("\r\n");

    // Start the DES engine in test mode
    set_cmd(CMD_START, port);
    wait_for_cmd_read(port);

    xil_printf("HW started! \r\n");
    xil_printf("\r\n");

    // Wait for the HW to finish 
    wait_for_done(port);

    xil_printf("Run complete! \r\n");
    xil_printf("Counter: %08x%08x \r\n", port[7], port[8]);
    xil_printf("\r\n");
}

void monitor_hw(unsigned int * port) {
    xil_printf("Monitoring the HW... \r\n");
    xil_printf("\r\n");

    uint16_t region = 0;

    uint32_t counter[2] = {0};
    uint32_t result[2] = {0};

    while(region <= 65535) {

        // TODO: Add a loop over all blocks here for multi block support (1)

        // Start the HW
        start_hw(region, port);

        // Wait for the HW to finish 
        wait_for_done(port);

        // Get the resulting counter and add to our counter
        result[1] = port[7];
        result[0] = port[8];

        mp_add(counter, result, counter, 2);

        // Restart the block
        restart_hw(port);

        // Increment region
        region = region + 1;

    }
    
}


void restart_hw(unsigned int * port) {
    set_cmd(CMD_RESTART, port);
    wait_for_cmd_read(port);

    xil_printf("HW restarted! \r\n");
    xil_printf("\r\n");
}
