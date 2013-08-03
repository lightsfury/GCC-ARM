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

#ifndef _STM32F30X_CONF_H_
#define _STM32F30X_CONF_H_

#include <stdint.h>

#ifdef USE_STM_F3_DISCOVERY_FILES
	#include <stm32f30x_ADC.h>
	#include <stm32f30x_CAN.h>
	#include <stm32f30x_COMP.h>
	#include <stm32f30x_CRC.h>
	#include <stm32f30x_DAC.h>
	#include <stm32f30x_DBGMCU.h>
	#include <stm32f30x_DMA.h>
	#include <stm32f30x_EXTI.h>
	#include <stm32f30x_FLASH.h>
	#include <stm32f30x_GPIO.h>
	#include <stm32f30x_I2C.h>
	#include <stm32f30x_IWDG.h>
	#include <stm32f30x_MISC.h>
	#include <stm32f30x_OPAMP.h>
	#include <stm32f30x_PWR.h>
	#include <stm32f30x_RCC.h>
	#include <stm32f30x_RTC.h>
	#include <stm32f30x_SPI.h>
	#include <stm32f30x_SYSCFG.h>
	#include <stm32f30x_TIM.h>
	#include <stm32f30x_USART.h>
	#include <stm32f30x_WWDG.h>
#endif // USE_STM_F3_DISCOVERY_FILES

#ifdef _GCC_ARM_USE_ASSERTIONS_
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
#endif // _GCC_ARM_USE_ASSERTIONS_

#endif // _STM32F30X_CONF_H_
