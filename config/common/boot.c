/**
Copyright (c) 2013 Robert Beam
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
**/

#if defined(_GCC_ARM_VENDOR_CHIP_INCLUDE)
	#include <_GCC_ARM_VENDOR_CHIP_INCLUDE>
#endif

#include <stdint.h>
#include <string.h>

#ifndef _WEAK_SYMBOL_
	#define _WEAK_SYMBOL_ __attribute__((weak))
#endif // _WEAK_SYMBOL_

//! Intential no-op function
void _WEAK_SYMBOL_ __libc_init_array(void) { /* no-op */ }

extern uint32_t _staticDataSource,
                _staticDataStart,
                _staticDataLength,
                _staticZeroStart,
                _staticZeroLength;

#ifdef _GCC_ARM_SYSTEM_INIT
	extern void SystemInit();
#endif // _GCC_ARM_SYSTEM_INIT

//! User entry point
extern int main(void);

void Reset_Handler(void)
{
	memcpy(&_staticDataStart, &_staticDataSource, (size_t)&_staticDataLength);
	memset(&_staticZeroStart, 0, (size_t)&_staticZeroLength);
	
	// If requested, call a system initializer
	#ifdef _GCC_ARM_SYSTEM_INIT
	SystemInit();
	#endif // _GCC_ARM_SYSTEM_INIT
	
	// Call the libc initializer
	__libc_init_array();
	
	// User entry point
	main();
	
	// Tail-call loop
	Reset_Handler();
}
