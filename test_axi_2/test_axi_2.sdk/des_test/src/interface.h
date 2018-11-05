#ifndef _INTERFACE_H_
#define _INTERFACE_H_

#include <stdint.h>
#include "sleep.h"

unsigned int * axi_port_0;
unsigned int * axi_port_1;

void interface_init();
void set_cmd(unsigned int cmd, unsigned int * port);
void set_region(uint16_t region, unsigned int * port);
void advance_test(unsigned int * port);

void print_reg_contents(unsigned int * port);

void wait_for_cmd_read(unsigned int * port);
void wait_for_test_res_ready(unsigned int * port);
void wait_for_done(unsigned int * port);

#endif
