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
		/** Intentional no-op loop */
		asm("nop");
	}
}

extern void _stackStart(void);

extern void Reset_Handler();

DEFAULT_ISR(NMI_Handler);
DEFAULT_ISR(HardFault_Handler);
DEFAULT_ISR(MemMange_Handler);
DEFAULT_ISR(BusFault_Handler);
DEFAULT_ISR(UsageFault_Handler);
DEFAULT_ISR(SVC_Handler);
DEFAULT_ISR(DebugMon_Handler);
DEFAULT_ISR(PendSV_Handler);
DEFAULT_ISR(SysTick_Handler);
DEFAULT_ISR(WWDG_IRQHandler);
DEFAULT_ISR(PVD_IRQHandler);
DEFAULT_ISR(TAMPER_STAMP_IRQHandler);
DEFAULT_ISR(RTC_WKUP_IRQHandler);
DEFAULT_ISR(FLASH_IRQHandler);
DEFAULT_ISR(RCC_IRQHandler);
DEFAULT_ISR(EXTI0_IRQHandler);
DEFAULT_ISR(EXTI1_IRQHandler);
DEFAULT_ISR(EXTI2_IRQHandler);
DEFAULT_ISR(EXTI3_IRQHandler);
DEFAULT_ISR(EXTI4_IRQHandler);
DEFAULT_ISR(DMA1_Channel1_IRQHandler);
DEFAULT_ISR(DMA1_Channel2_IRQHandler);
DEFAULT_ISR(DMA1_Channel3_IRQHandler);
DEFAULT_ISR(DMA1_Channel4_IRQHandler);
DEFAULT_ISR(DMA1_Channel5_IRQHandler);
DEFAULT_ISR(DMA1_Channel6_IRQHandler);
DEFAULT_ISR(DMA1_Channel7_IRQHandler);
DEFAULT_ISR(ADC1_IRQHandler);
DEFAULT_ISR(EXTI9_5_IRQHandler);
DEFAULT_ISR(TIM1_BRK_TIM15_IRQHandler);
DEFAULT_ISR(TIM1_UP_TIM16_IRQHandler);
DEFAULT_ISR(TIM1_TRG_COM_TIM17_IRQHandler);
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
DEFAULT_ISR(RTCAlarm_IRQHandler);
DEFAULT_ISR(CEC_IRQHandler);
DEFAULT_ISR(TIM12_IRQHandler);
DEFAULT_ISR(TIM13_IRQHandler);
DEFAULT_ISR(TIM14_IRQHandler);
DEFAULT_ISR(ADC3_IRQHandler);
DEFAULT_ISR(FSMC_IRQHandler);
DEFAULT_ISR(TIM5_IRQHandler);
DEFAULT_ISR(SPI3_IRQHandler);
DEFAULT_ISR(UART4_IRQHandler);
DEFAULT_ISR(UART5_IRQHandler);
DEFAULT_ISR(TIM6_DAC_IRQHandler);
DEFAULT_ISR(TIM7_IRQHandler);
DEFAULT_ISR(DMA2_Channel1_IRQHandler);
DEFAULT_ISR(DMA2_Channel2_IRQHandler);
DEFAULT_ISR(DMA2_Channel3_IRQHandler);
DEFAULT_ISR(DMA2_Channel4_5_IRQHandler);
DEFAULT_ISR(DMA2_Channel5_IRQHandler);

__attribute__((section(".isr_vector")))

static void (* const __isr_vector[])(void) = {
	_stackStart,
	Reset_Handler,
	NMI_Handler,
	HardFault_Handler,
	MemMange_Handler,
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
	TAMPER_STAMP_IRQHandler,
	RTC_WKUP_IRQHandler,
	FLASH_IRQHandler,
	RCC_IRQHandler,
	EXTI0_IRQHandler,
	EXTI1_IRQHandler,
	EXTI2_IRQHandler,
	EXTI3_IRQHandler,
	EXTI4_IRQHandler,
	DMA1_Channel1_IRQHandler,
	DMA1_Channel2_IRQHandler,
	DMA1_Channel3_IRQHandler,
	DMA1_Channel4_IRQHandler,
	DMA1_Channel5_IRQHandler,
	DMA1_Channel6_IRQHandler,
	DMA1_Channel7_IRQHandler,
	ADC1_IRQHandler,
	0, 0, 0, 0,
	EXTI9_5_IRQHandler,
	TIM1_BRK_TIM15_IRQHandler,
	TIM1_UP_TIM16_IRQHandler,
	TIM1_TRG_COM_TIM17_IRQHandler,
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
	RTCAlarm_IRQHandler,
	CEC_IRQHandler,
	TIM12_IRQHandler,
	TIM13_IRQHandler,
	TIM14_IRQHandler,
	0,
	ADC3_IRQHandler,
	FSMC_IRQHandler,
	0,
	TIM5_IRQHandler,
	SPI3_IRQHandler,
	UART4_IRQHandler,
	UART5_IRQHandler,
	TIM6_DAC_IRQHandler,
	TIM7_IRQHandler,
	DMA2_Channel1_IRQHandler,
	DMA2_Channel2_IRQHandler,
	DMA2_Channel3_IRQHandler,
	DMA2_Channel4_5_IRQHandler,
	DMA2_Channel5_IRQHandler,
	0, 0, 0, 0, 0, 0, 0, 0,
	0,
	[0x1CC/4] = 0xF108F85F
};
