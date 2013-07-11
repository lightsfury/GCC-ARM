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

#ifndef _STM32F10X_CONF_H_
#define _STM32F10X_CONF_H_

/**
	This file is automatically included by STF32F10x.h. As such, you should
	include at least:
		Peripheral driver header files
		Project-global functions and types
		Interrupt service routines
**/

/**
	The STM32vl discovery files require that the conf.h file include the
	neccesary header files.
**/
#ifdef STM_DISCOVERY_FILES
	#include <misc.h>
	#include <stm32f10x_exti.h>
	#include <stm32f10x_gpio.h>
	#include <stm32f10x_rcc.h>
	#include <stm32f10x_pwr.h>
	#include <stm32f10x_i2c.h>
	#include <stm32vldiscovery.h>
#endif

#ifdef __cplusplus
	#define EXTERN		extern
	#define EXTERN_C	extern "C"
#else
	#define EXTERN		extern
	#define EXTERN_C	extern
#endif

EXTERN_C void InitPeripheralDevices();
EXTERN_C void Delay(uint32_t);
EXTERN_C uint32_t GetTickCount();

#ifdef USE_FULL_ASSERT
	/**
		The STM peripheral library makes extensive use of the user-defined
		assert_param macro. Such extensive use makes failure identification much
		simpler.
	**/
	#define assert_param(e) {if (!(e)) {               \
		assert_failed((uint8_t*)__FILE__, __LINE__); } }
	
	void assert_failed(uint8_t* file, uint32_t lineNumber);
#else
	/* No-op assertion */
	#define assert_param(...) 
#endif // USE_FULL_ASSERT

#endif // _STM32F10X_CONF_H_

