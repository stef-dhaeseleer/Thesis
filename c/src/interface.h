#ifndef _INTERFACE_H_
#define _INTERFACE_H_

#include <stdint.h>
#include "sleep.h"

unsigned int * axi_port;

void interface_init();
void set_cmd(unsigned int cmd);
void set_region(uint16_t region);
void advance_test();

void wait_for_cmd_read();
void wait_for_test_res_ready();
void wait_for_done();

#endif
