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

#ifndef DEFAULT_ISR
	#define DEFAULT_ISR(name) void name(void)         \
		__attribute__((weak, alias("Default_Handler")))
#endif // DEFAULT_ISR

void Default_Handler()
{
	while (1)
	{
		/* Intentional no-op loop */
		asm("nop");
	}
}

extern void _stackStart(void);

extern void Reset_Handler();

DEFAULT_ISR(NMI_Handler);
DEFAULT_ISR(HardFault_Handler);
DEFAULT_ISR(MemManage_Handler);
DEFAULT_ISR(BusFault_Handler);
DEFAULT_ISR(UsageFault_Handler);
DEFAULT_ISR(SVC_Handler);
DEFAULT_ISR(DebugMon_Handler);
DEFAULT_ISR(PendSV_Handler);
DEFAULT_ISR(SysTick_Handler);

DEFAULT_ISR(WWDG_IRQHandler);
DEFAULT_ISR(PVD_IRQHandler);
DEFAULT_ISR(TAMP_STAMP_IRQHandler);
DEFAULT_ISR(RTC_WKUP_IRQHandler);
DEFAULT_ISR(FLASH_IRQHandler);
DEFAULT_ISR(RCC_IRQHandler);
DEFAULT_ISR(EXTI0_IRQHandler);
DEFAULT_ISR(EXTI1_IRQHandler);
DEFAULT_ISR(EXTI2_IRQHandler);
DEFAULT_ISR(EXTI3_IRQHandler);
DEFAULT_ISR(EXTI4_IRQHandler);
DEFAULT_ISR(DMA1_Stream0_IRQHandler);
DEFAULT_ISR(DMA1_Stream1_IRQHandler);
DEFAULT_ISR(DMA1_Stream2_IRQHandler);
DEFAULT_ISR(DMA1_Stream3_IRQHandler);
DEFAULT_ISR(DMA1_Stream4_IRQHandler);
DEFAULT_ISR(DMA1_Stream5_IRQHandler);
DEFAULT_ISR(DMA1_Stream6_IRQHandler);
DEFAULT_ISR(ADC_IRQHandler);
DEFAULT_ISR(CAN1_TX_IRQHandler);
DEFAULT_ISR(CAN1_RX0_IRQHandler);
DEFAULT_ISR(CAN1_RX1_IRQHandler);
DEFAULT_ISR(CAN1_SCE_IRQHandler);
DEFAULT_ISR(EXTI9_5_IRQHandler);
DEFAULT_ISR(TIM1_BRK_TIM9_IRQHandler);
DEFAULT_ISR(TIM1_UP_TIM10_IRQHandler);
DEFAULT_ISR(TIM1_TRG_COM_TIM11_IRQHandler);
DEFAULT_ISR(TIM1_CC_IRQHandler);
DEFAULT_ISR(TIM2_IRQHandler);
DEFAULT_ISR(TIM3_IRQHandler);
DEFAULT_ISR(TIM4_IRQHandler);
DEFAULT_ISR(I2C1_EV_IRQHandler);
DEFAULT_ISR(I2C1_ER_IRQHandler);
DEFAULT_ISR(I2C2_EV_IRQHandler);
DEFAULT_ISR(I2C2_ER_IRQHandler);
DEFAULT_ISR(SPI1_IRQHandler);
DEFAULT_ISR(SPI2_IRQHandler);
DEFAULT_ISR(USART1_IRQHandler);
DEFAULT_ISR(USART2_IRQHandler);
DEFAULT_ISR(USART3_IRQHandler);
DEFAULT_ISR(EXTI15_10_IRQHandler);
DEFAULT_ISR(RTC_Alarm_IRQHandler);
DEFAULT_ISR(OTG_FS_WKUP_IRQHandler);
DEFAULT_ISR(TIM8_BRK_TIM12_IRQHandler);
DEFAULT_ISR(TIM8_UP_TIM13_IRQHandler);
DEFAULT_ISR(TIM8_TRG_COM_TIM14_IRQHandler);
DEFAULT_ISR(TIM8_CC_IRQHandler);
DEFAULT_ISR(DMA1_Stream7_IRQHandler);
DEFAULT_ISR(FMC_IRQHandler);
DEFAULT_ISR(SDIO_IRQHandler);
DEFAULT_ISR(TIM5_IRQHandler);
DEFAULT_ISR(SPI3_IRQHandler);
DEFAULT_ISR(UART4_IRQHandler);
DEFAULT_ISR(UART5_IRQHandler);
DEFAULT_ISR(TIM6_DAC_IRQHandler);
DEFAULT_ISR(TIM7_IRQHandler);
DEFAULT_ISR(DMA2_Stream0_IRQHandler);
DEFAULT_ISR(DMA2_Stream1_IRQHandler);
DEFAULT_ISR(DMA2_Stream2_IRQHandler);
DEFAULT_ISR(DMA2_Stream3_IRQHandler);
DEFAULT_ISR(DMA2_Stream4_IRQHandler);
DEFAULT_ISR(ETH_IRQHandler);
DEFAULT_ISR(ETH_WKUP_IRQHandler);
DEFAULT_ISR(CAN2_TX_IRQHandler);
DEFAULT_ISR(CAN2_RX0_IRQHandler);
DEFAULT_ISR(CAN2_RX1_IRQHandler);
DEFAULT_ISR(CAN2_SCE_IRQHandler);
DEFAULT_ISR(OTG_FS_IRQHandler);
DEFAULT_ISR(DMA2_Stream5_IRQHandler);
DEFAULT_ISR(DMA2_Stream6_IRQHandler);
DEFAULT_ISR(DMA2_Stream7_IRQHandler);
DEFAULT_ISR(USART6_IRQHandler);
DEFAULT_ISR(I2C3_EV_IRQHandler);
DEFAULT_ISR(I2C3_ER_IRQHandler);
DEFAULT_ISR(OTG_HS_EP1_OUT_IRQHandler);
DEFAULT_ISR(OTG_HS_EP1_IN_IRQHandler);
DEFAULT_ISR(OTG_HS_WKUP_IRQHandler);
DEFAULT_ISR(OTG_HS_IRQHandler);
DEFAULT_ISR(DCMI_IRQHandler);
DEFAULT_ISR(CRYP_IRQHandler);
DEFAULT_ISR(HASH_RNG_IRQHandler);
DEFAULT_ISR(FPU_IRQHandler);
DEFAULT_ISR(UART7_IRQHandler);
DEFAULT_ISR(UART8_IRQHandler);
DEFAULT_ISR(SPI4_IRQHandler);
DEFAULT_ISR(SPI5_IRQHandler);
DEFAULT_ISR(SPI6_IRQHandler);
DEFAULT_ISR(SAI1_IRQHandler);
DEFAULT_ISR(LTDC_IRQHandler);
DEFAULT_ISR(LTDC_ER_IRQHandler);
DEFAULT_ISR(DMA2D_IRQHandler);

__attribute__((section(".isr_vector")))

static void (* const __isr_vector[])(void) = {
	_stackStart,
  Reset_Handler,
  NMI_Handler,
  HardFault_Handler,
  MemManage_Handler,
  BusFault_Handler,
  UsageFault_Handler,
  0, 0, 0, 0,
  SVC_Handler,
  DebugMon_Handler,
  0,
  PendSV_Handler,
  SysTick_Handler,
  WWDG_IRQHandler,
  PVD_IRQHandler,
  TAMP_STAMP_IRQHandler,
  RTC_WKUP_IRQHandler,
  FLASH_IRQHandler,
  RCC_IRQHandler,
  EXTI0_IRQHandler,
  EXTI1_IRQHandler,
  EXTI2_IRQHandler,
  EXTI3_IRQHandler,
  EXTI4_IRQHandler,
  DMA1_Stream0_IRQHandler,
  DMA1_Stream1_IRQHandler,
  DMA1_Stream2_IRQHandler,
  DMA1_Stream3_IRQHandler,
  DMA1_Stream4_IRQHandler,
  DMA1_Stream5_IRQHandler,
  DMA1_Stream6_IRQHandler,
  ADC_IRQHandler,
  CAN1_TX_IRQHandler,
  CAN1_RX0_IRQHandler,
  CAN1_RX1_IRQHandler,
  CAN1_SCE_IRQHandler,
  EXTI9_5_IRQHandler,
  TIM1_BRK_TIM9_IRQHandler,
  TIM1_UP_TIM10_IRQHandler,
  TIM1_TRG_COM_TIM11_IRQHandler,
  TIM1_CC_IRQHandler,
  TIM2_IRQHandler,
  TIM3_IRQHandler,
  TIM4_IRQHandler,
  I2C1_EV_IRQHandler,
  I2C1_ER_IRQHandler,
  I2C2_EV_IRQHandler,
  I2C2_ER_IRQHandler,
  SPI1_IRQHandler,
  SPI2_IRQHandler,
  USART1_IRQHandler,
  USART2_IRQHandler,
  USART3_IRQHandler,
  EXTI15_10_IRQHandler,
  RTC_Alarm_IRQHandler,
  OTG_FS_WKUP_IRQHandler,
  TIM8_BRK_TIM12_IRQHandler,
  TIM8_UP_TIM13_IRQHandler,
  TIM8_TRG_COM_TIM14_IRQHandler,
  TIM8_CC_IRQHandler,
  DMA1_Stream7_IRQHandler,
  FMC_IRQHandler,
  SDIO_IRQHandler,
  TIM5_IRQHandler,
  SPI3_IRQHandler,
  UART4_IRQHandler,
  UART5_IRQHandler,
  TIM6_DAC_IRQHandler,
  TIM7_IRQHandler,
  DMA2_Stream0_IRQHandler,
  DMA2_Stream1_IRQHandler,
  DMA2_Stream2_IRQHandler,
  DMA2_Stream3_IRQHandler,
  DMA2_Stream4_IRQHandler,
  ETH_IRQHandler,
  ETH_WKUP_IRQHandler,
  CAN2_TX_IRQHandler,
  CAN2_RX0_IRQHandler,
  CAN2_RX1_IRQHandler,
  CAN2_SCE_IRQHandler,
  OTG_FS_IRQHandler,
  DMA2_Stream5_IRQHandler,
  DMA2_Stream6_IRQHandler,
  DMA2_Stream7_IRQHandler,
  USART6_IRQHandler,
  I2C3_EV_IRQHandler,
  I2C3_ER_IRQHandler,
  OTG_HS_EP1_OUT_IRQHandler,
  OTG_HS_EP1_IN_IRQHandler,
  OTG_HS_WKUP_IRQHandler,
  OTG_HS_IRQHandler,
  DCMI_IRQHandler,
  CRYP_IRQHandler,
  HASH_RNG_IRQHandler,
  FPU_IRQHandler,
  UART7_IRQHandler,
  UART8_IRQHandler,
  SPI4_IRQHandler,
  SPI5_IRQHandler,
  SPI6_IRQHandler,
  SAI1_IRQHandler,
  LTDC_IRQHandler,
  LTDC_ER_IRQHandler,
  DMA2D_IRQHandler
};
