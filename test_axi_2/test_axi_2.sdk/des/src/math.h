#ifndef _SW_H_
#define _SW_H_

#include <stdint.h>

#include "xil_printf.h"

// Calculates res = a + b.
// a and b represent large integers stored in uint32_t arrays
// a and b are arrays of size elements, res has size+1 elements
void mp_add(uint32_t *a, uint32_t *b, uint32_t *res, uint32_t size);

uint32_t compare(uint32_t *a, uint32_t *b, uint32_t size);

void arrayprint(uint32_t *array, uint32_t size);

#endif
