#ifndef _HW_H_
#define _HW_H_

#include <stdint.h>
#include <stdio.h>

//#include "libxil.a"

#include "interface.h"
#include "math.h"

#define CMD_READ_REGION             0
#define CMD_START                   1
#define CMD_TEST_MODE               2
#define CMD_RESTART                 3
void test_hw(unsigned int * port);
void restart_hw(unsigned int * port);
void start_hw(uint16_t region, unsigned int * port);
void monitor_hw(unsigned int * port);

extern void set_cmd(unsigned int cmd, unsigned int * port);

#endif
