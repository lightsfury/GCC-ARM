#include <stm32f10x.h>
#include <core_cm3.h>
#include <stdint.h>
#include <string.h>

#ifndef _WEAK_SYMBOL_
	#define _WEAK_SYMBOL_ __attribute__((weak))
#endif

#define NVIC_HANDLER(a) void a (void) __attribute__((weak, alias("Default_Handler")))

extern void _stackStart(void);

void Reset_Handler(void);
void Default_Handler(void)
{
	while (1);
}

void _WEAK_SYMBOL_ __libc_init_array(void) { /* no-op */ }

extern uint32_t _staticDataInit,
                _staticDataAddr,
				_staticDataLength,
				_staticZeroAddr,
				_staticZeroLength;

extern int main(void);

void Reset_Handler(void)
{
	static int forceDataSection = 1;
	memcpy(&_staticDataAddr, &_staticDataInit, &_staticDataLength);
	memset(&_staticZeroAddr, 0, &_staticZeroLength);
	
	SystemInit();
	__libc_init_array();
	main();
	asm("b Reset_Handler");
}

NVIC_HANDLER(NMI_Handler);
NVIC_HANDLER(HardFault_Handler);
NVIC_HANDLER(MemMange_Handler);
NVIC_HANDLER(BusFault_Handler);
NVIC_HANDLER(UsageFault_Handler);
NVIC_HANDLER(SVC_Handler);
NVIC_HANDLER(DebugMon_Handler);
NVIC_HANDLER(PendSV_Handler);
NVIC_HANDLER(SysTick_Handler);
NVIC_HANDLER(WWDG_IRQHandler);
NVIC_HANDLER(PVD_IRQHandler);
NVIC_HANDLER(TAMPER_STAMP_IRQHandler);
NVIC_HANDLER(RTC_WKUP_IRQHandler);
NVIC_HANDLER(FLASH_IRQHandler);
NVIC_HANDLER(RCC_IRQHandler);
NVIC_HANDLER(EXTI0_IRQHandler);
NVIC_HANDLER(EXTI1_IRQHandler);
NVIC_HANDLER(EXTI2_IRQHandler);
NVIC_HANDLER(EXTI3_IRQHandler);
NVIC_HANDLER(EXTI4_IRQHandler);
NVIC_HANDLER(DMA1_Channel1_IRQHandler);
NVIC_HANDLER(DMA1_Channel2_IRQHandler);
NVIC_HANDLER(DMA1_Channel3_IRQHandler);
NVIC_HANDLER(DMA1_Channel4_IRQHandler);
NVIC_HANDLER(DMA1_Channel5_IRQHandler);
NVIC_HANDLER(DMA1_Channel6_IRQHandler);
NVIC_HANDLER(DMA1_Channel7_IRQHandler);
NVIC_HANDLER(ADC1_IRQHandler);
NVIC_HANDLER(EXTI9_5_IRQHandler);
NVIC_HANDLER(TIM1_BRK_TIM15_IRQHandler);
NVIC_HANDLER(TIM1_UP_TIM16_IRQHandler);
NVIC_HANDLER(TIM1_TRG_COM_TIM17_IRQHandler);
NVIC_HANDLER(TIM1_CC_IRQHandler);
NVIC_HANDLER(TIM2_IRQHandler);
NVIC_HANDLER(TIM3_IRQHandler);
NVIC_HANDLER(TIM4_IRQHandler);
NVIC_HANDLER(I2C1_EV_IRQHandler);
NVIC_HANDLER(I2C1_ER_IRQHandler);
NVIC_HANDLER(I2C2_EV_IRQHandler);
NVIC_HANDLER(I2C2_ER_IRQHandler);
NVIC_HANDLER(SPI1_IRQHandler);
NVIC_HANDLER(SPI2_IRQHandler);
NVIC_HANDLER(USART1_IRQHandler);
NVIC_HANDLER(USART2_IRQHandler);
NVIC_HANDLER(USART3_IRQHandler);
NVIC_HANDLER(EXTI15_10_IRQHandler);
NVIC_HANDLER(RTCAlarm_IRQHandler);
NVIC_HANDLER(CEC_IRQHandler);
NVIC_HANDLER(TIM12_IRQHandler);
NVIC_HANDLER(TIM13_IRQHandler);
NVIC_HANDLER(TIM14_IRQHandler);
NVIC_HANDLER(ADC3_IRQHandler);
NVIC_HANDLER(FSMC_IRQHandler);
NVIC_HANDLER(TIM5_IRQHandler);
NVIC_HANDLER(SPI3_IRQHandler);
NVIC_HANDLER(UART4_IRQHandler);
NVIC_HANDLER(UART5_IRQHandler);
NVIC_HANDLER(TIM6_DAC_IRQHandler);
NVIC_HANDLER(TIM7_IRQHandler);
NVIC_HANDLER(DMA2_Channel1_IRQHandler);
NVIC_HANDLER(DMA2_Channel2_IRQHandler);
NVIC_HANDLER(DMA2_Channel3_IRQHandler);
NVIC_HANDLER(DMA2_Channel4_5_IRQHandler);
NVIC_HANDLER(DMA2_Channel5_IRQHandler);

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
#if defined (STM32F10X_LD_VL) || (defined STM32F10X_MD_VL) 
	[0x1CC/4] = 0xF108F85F
#elif defined (STM32F10X_HD_VL)
	[0x1E0/4] = 0xF108F85F
#endif

};
