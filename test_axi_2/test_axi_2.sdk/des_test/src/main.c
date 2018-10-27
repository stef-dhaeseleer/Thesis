/*
 ============================================================================
 Name        : main.c
 Author      : Stef D'haeseleer
 Version     :
 Copyright   : Your copyright notice
 Description : Hello World in C
 ============================================================================
 */

#include <stdio.h>

#include "xil_printf.h"
#include "xil_cache.h"

#include "platform/platform.h"
#include "interface.h"
#include "hw.h"

/*
 * Main of the control host for the DES cryptanalysis implementation.
 *
 */

int main() {

    xil_printf("Initializing the platform... \r\n");
    xil_printf("\r\n");

    init_platform();
    interface_init();

    xil_printf("Platform initialized! \r\n");
    xil_printf("\r\n");

    // Run a test on the HW
    test_hw();
    restart_hw();

    return 0;
}
