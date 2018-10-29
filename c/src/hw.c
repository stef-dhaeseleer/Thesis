
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

void test_hw(){

    uint32_t test_1;
    uint32_t test_2;

    xil_printf("Testing the platform... \r\n");
    xil_printf("\r\n");

    // First set the region to be used to all zeros
    uint16_t region = 0;
    set_region(region);
    // TODO: is it okay to just do these after eachother or should I leave time in between? (1)
    set_cmd(CMD_READ_REGION);
    wait_for_cmd_read();

    xil_printf("Selected region: %x \r\n", region);
    xil_printf("\r\n");

    // Start the DES engine in test mode
    set_cmd(CMD_TEST_MODE);
    wait_for_cmd_read();

    // Wait untill the first ciphertext result is ready
    wait_for_test_res_ready();

    // Now check and print the result
    // TODO: also add a check to see if the values are correct and report at the end of all tests (1)

    test_1 = 0x166b40b4;
    test_2 = 0x4aba4bd6;

    xil_printf("Test result: \r\n");
    xil_printf("Message: %x%x \r\n", 0, 1);
    xil_printf("Ciphertext: %x%x \r\n", axi_port[5], axi_port[6]);
    xil_printf("Expected: %x%x \r\n", test_1, test_2);
    xil_printf("\r\n");

    //***********************************************************************
    advance_test();
    // TODO: is it okay to just do these after eachother or should I leave time in between? (1)
    wait_for_test_res_ready();

    test_1 = 0x06e7ea22;
    test_2 = 0xce92708f;

    xil_printf("Test result: \r\n");
    xil_printf("Message: %x%x \r\n", 0, 2);
    xil_printf("Ciphertext: %x%x \r\n", axi_port[5], axi_port[6]);
    xil_printf("Expected: %x%x \r\n", test_1, test_2);
    xil_printf("\r\n");

    //***********************************************************************
    advance_test();
    wait_for_test_res_ready();

    test_1 = 0x4eb190c9;
    test_2 = 0xa2fa169c;

    xil_printf("Test result: \r\n");
    xil_printf("Message: %x%x \r\n", 0, 3);
    xil_printf("Ciphertext: %x%x \r\n", axi_port[5], axi_port[6]);
    xil_printf("Expected: %x%x \r\n", test_1, test_2);
    xil_printf("\r\n");

    xil_printf("Testing completed! \r\n");
    xil_printf("\r\n");
}

void start_hw(uint16_t region) {
    xil_printf("Starting the HW... \r\n");
    xil_printf("\r\n");

    // First set the region to be used to all zeros
    set_region(region);
    // TODO: is it okay to just do these after eachother or should I leave time in between? (1)
    set_cmd(CMD_READ_REGION);
    wait_for_cmd_read();

    xil_printf("Selected region: %x \r\n", region);
    xil_printf("\r\n");

    // Start the DES engine in test mode
    set_cmd(CMD_START);
    wait_for_cmd_read();

    xil_printf("HW started! %x \r\n");
    xil_printf("\r\n");

    // Wait for the HW to finish 
    //wait_for_done();
}

void monitor_hw() {
    xil_printf("Monitoring the HW... \r\n");
    xil_printf("\r\n");

    uint16_t region = 0;

    uint32_t counter[2] = 0;
    uint32_t result[2] = 0;

    while(region <= 65535) {

        // TODO: Add a loop over all blocks here for multi block support (1)

        // Start the HW
        start_hw(region);

        // Wait for the HW to finish 
        wait_for_done();

        // Get the resulting counter and add to our counter
        result[1] = axi_port[7];
        result[0] = axi_port[8];

        mp_add(counter, result, counter, 2);

        // Restart the block
        restart_hw();

        // Increment region
        region = region + 1;

    }
    
}


void restart_hw() {
    set_cmd(CMD_RESTART);
    wait_for_cmd_read();
}