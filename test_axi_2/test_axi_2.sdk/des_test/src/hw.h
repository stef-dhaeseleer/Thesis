#ifndef _HW_H_
#define _HW_H_

#include <stdint.h>

#include "interface.h"
#include "math.h"

#include "xil_printf.h"
#include "sleep.h"

#define CMD_READ_REGION             0
#define CMD_START                   1
#define CMD_TEST_MODE               2
#define CMD_RESTART                 3


void test_hw();
void restart_hw();
void start_hw(uint16_t region);

#endif
