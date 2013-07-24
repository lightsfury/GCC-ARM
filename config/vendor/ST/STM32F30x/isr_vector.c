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
DEFAULT_ISR(MemManage_Handler);
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
DEFAULT_ISR(EXTI2_TS_IRQHandler);
DEFAULT_ISR(EXTI3_IRQHandler);
DEFAULT_ISR(EXTI4_IRQHandler);
DEFAULT_ISR(DMA1_Channel1_IRQHandler);
DEFAULT_ISR(DMA1_Channel2_IRQHandler);
DEFAULT_ISR(DMA1_Channel3_IRQHandler);
DEFAULT_ISR(DMA1_Channel4_IRQHandler);
DEFAULT_ISR(DMA1_Channel5_IRQHandler);
DEFAULT_ISR(DMA1_Channel6_IRQHandler);
DEFAULT_ISR(DMA1_Channel7_IRQHandler);
DEFAULT_ISR(ADC1_2_IRQHandler);
DEFAULT_ISR(USB_HP_CAN1_TX_IRQHandler);
DEFAULT_ISR(USB_LP_CAN1_RX0_IRQHandler);
DEFAULT_ISR(CAN1_RX1_IRQHandler);
DEFAULT_ISR(CAN1_SCE_IRQHandler);
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
DEFAULT_ISR(RTC_Alarm_IRQHandler);
DEFAULT_ISR(USBWakeUp_IRQHandler);
DEFAULT_ISR(TIM8_BRK_IRQHandler);
DEFAULT_ISR(TIM8_UP_IRQHandler);
DEFAULT_ISR(TIM8_TRG_COM_IRQHandler);
DEFAULT_ISR(TIM8_CC_IRQHandler);
DEFAULT_ISR(ADC3_IRQHandler);
DEFAULT_ISR(SPI3_IRQHandler);
DEFAULT_ISR(UART4_IRQHandler);
DEFAULT_ISR(UART5_IRQHandler);
DEFAULT_ISR(TIM6_DAC_IRQHandler);
DEFAULT_ISR(TIM7_IRQHandler);
DEFAULT_ISR(DMA2_Channel1_IRQHandler);
DEFAULT_ISR(DMA2_Channel2_IRQHandler);
DEFAULT_ISR(DMA2_Channel3_IRQHandler);
DEFAULT_ISR(DMA2_Channel4_IRQHandler);
DEFAULT_ISR(DMA2_Channel5_IRQHandler);
DEFAULT_ISR(ADC4_IRQHandler);
DEFAULT_ISR(COMP1_2_3_IRQHandler);
DEFAULT_ISR(COMP4_5_6_IRQHandler);
DEFAULT_ISR(COMP7_IRQHandler);
DEFAULT_ISR(USB_HP_IRQHandler);
DEFAULT_ISR(USB_LP_IRQHandler);
DEFAULT_ISR(USBWakeUp_RMP_IRQHandler);
DEFAULT_ISR(FPU_IRQHandler);

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
	TAMPER_STAMP_IRQHandler,
	RTC_WKUP_IRQHandler,
	FLASH_IRQHandler,
	RCC_IRQHandler,
	EXTI0_IRQHandler,
	EXTI1_IRQHandler,
	EXTI2_TS_IRQHandler,
	EXTI3_IRQHandler,
	EXTI4_IRQHandler,
	DMA1_Channel1_IRQHandler,
	DMA1_Channel2_IRQHandler,
	DMA1_Channel3_IRQHandler,
	DMA1_Channel4_IRQHandler,
	DMA1_Channel5_IRQHandler,
	DMA1_Channel6_IRQHandler,
	DMA1_Channel7_IRQHandler,
	ADC1_2_IRQHandler,
	USB_HP_CAN1_TX_IRQHandler,
	USB_LP_CAN1_RX0_IRQHandler,
	CAN1_RX1_IRQHandler,
	CAN1_SCE_IRQHandler,
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
	RTC_Alarm_IRQHandler,
	USBWakeUp_IRQHandler,
	TIM8_BRK_IRQHandler,
	TIM8_UP_IRQHandler,
	TIM8_TRG_COM_IRQHandler,
	TIM8_CC_IRQHandler,
	ADC3_IRQHandler,
	0, 0, 0,
	SPI3_IRQHandler,
	UART4_IRQHandler,
	UART5_IRQHandler,
	TIM6_DAC_IRQHandler,
	TIM7_IRQHandler,
	DMA2_Channel1_IRQHandler,
	DMA2_Channel2_IRQHandler,
	DMA2_Channel3_IRQHandler,
	DMA2_Channel4_IRQHandler,
	DMA2_Channel5_IRQHandler,
	ADC4_IRQHandler,
	0, 0,
	COMP1_2_3_IRQHandler,
	COMP4_5_6_IRQHandler,
	COMP7_IRQHandler,
	0, 0, 0, 0, 0, 0, 0,
	USB_HP_IRQHandler,
	USB_LP_IRQHandler,
	USBWakeUp_RMP_IRQHandler,
	0, 0, 0, 0,
	FPU_IRQHandler
};
