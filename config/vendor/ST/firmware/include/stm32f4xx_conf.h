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

#ifndef _STM32F4XX_CONF_H_
#define _STM32F4XX_CONF_H_

#include <stdint.h>

#ifdef USE_STM32F429I_DISCO
  #include "stm32f4xx_adc.h"
  #include "stm32f4xx_can.h"
  #include "stm32f4xx_crc.h"
  #include "stm32f4xx_cryp.h"
  #include "stm32f4xx_dac.h"
  #include "stm32f4xx_dbgmcu.h"
  #include "stm32f4xx_dcmi.h"
  #include "stm32f4xx_dma.h"
  #include "stm32f4xx_dma2d.h"
  #include "stm32f4xx_exti.h"
  #include "stm32f4xx_flash.h"
  #include "stm32f4xx_fmc.h"
  #include "stm32f4xx_fsmc.h"
  #include "stm32f4xx_hash.h"
  #include "stm32f4xx_gpio.h"
  #include "stm32f4xx_i2c.h"
  #include "stm32f4xx_iwdg.h"
  #include "stm32f4xx_ltdc.h"
  #include "stm32f4xx_pwr.h"
  #include "stm32f4xx_rcc.h"
  #include "stm32f4xx_rng.h"
  #include "stm32f4xx_rtc.h"
  #include "stm32f4xx_sai.h"
  #include "stm32f4xx_sdio.h"
  #include "stm32f4xx_spi.h"
  #include "stm32f4xx_syscfg.h"
  #include "stm32f4xx_tim.h"
  #include "stm32f4xx_usart.h"
  #include "stm32f4xx_wwdg.h"
  #include "misc.h"
#endif // USE_STM32F429I_DISCO

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

#endif // _STM32F4XX_CONF_H_
