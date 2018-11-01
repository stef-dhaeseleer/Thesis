/*
 ============================================================================
 Name        : main.c
 Author      : Stef D'haeseleer
 Version     :
 Copyright   :
 Description :
 ============================================================================
 */

#include <stdio.h>

#include "xil_printf.h"
#include "xil_cache.h"
#include "sleep.h"

#include "platform.h"
#include "interface.h"
#include "hw.h"

/*
 * Main of the control host for the DES cryptanalysis implementation.
 *
 */

int main() {

	uint32_t region = 0x00000000;

	xil_printf("\r\n");
    xil_printf("Initializing the platform... \r\n");
    xil_printf("\r\n");

    init_platform();
    interface_init();

    xil_printf("Platform initialized! \r\n");
    xil_printf("\r\n");

    // Run a test on the HW
    test_hw();
    sleep(5);

    restart_hw();
    sleep(2);

    start_hw(region);

    return 0;
}
