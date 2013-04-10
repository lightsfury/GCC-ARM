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
#include <stm32f10x.h>
#include <stm32f10x_conf.h>
#include <stdint.h>
/**
	This should should contain any required interrupt service routines. ISR
	methods have a void(void) call signature. That is, they take no arguments
	and return no values.
**/

static volatile uint32_t _DelayCounter;

/**
	Example ISR. Handles the SYSTICK interrupt service routine. Automatic names
	can be found in the platform.d/boot_$(USER_DEVICE_CLASS).c file.
**/
void SysTick_Handler()
{
	_DelayCounter--;
}
