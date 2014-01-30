#if defined(STM32F30X)
	#include <STM32F30X.h>
	#include <stm32f3_discovery.h>
#elif defined(STM32F10X_MD_VL)
	#include <STM32F10X.h>
	#include <stm32vldiscovery.h>
#elif defined(STM32F429_439xx)
  #include <STM32F4XX.h>
  #include <stm32f429i_discovery.h>
#else
	#error Did not detect a supported platform.
#endif

#include <stdint.h>
#include <stdio.h>
#include <string.h>

void InitPeripheralDevices();

volatile uint32_t TickCount = 0;
volatile uint32_t DelayCount = 0;

void SysTick_Handler()
{
	TickCount++;
	DelayCount--;
}

void Delay(uint32_t ms)
{
	DelayCount = ms;
	while (DelayCount > 0);
}

int main()
{
	InitPeripheralDevices();
	
	while (1)
	{
#if defined(STM32F30X)
    /* Clockwise rotation in 50ms steps */
		STM_EVAL_LEDToggle(LED3);
		Delay(50);
		STM_EVAL_LEDToggle(LED5);
		Delay(50);
		STM_EVAL_LEDToggle(LED7);
		Delay(50);
		STM_EVAL_LEDToggle(LED9);
		Delay(50);
		STM_EVAL_LEDToggle(LED10);
		Delay(50);
		STM_EVAL_LEDToggle(LED8);
		Delay(50); 
		STM_EVAL_LEDToggle(LED6);
		Delay(50);
		STM_EVAL_LEDToggle(LED4);
		Delay(50);
#elif defined(STM32F10X_MD_VL)
    /* Left-right toggle in 100ms steps */
		STM32vldiscovery_LEDToggle(LED3);
		Delay(100);
		STM32vldiscovery_LEDToggle(LED4);
		Delay(100);
#elif defined(STM32F429_439xx)
    STM_EVAL_LEDToggle(LED3);
    Delay(100);
    STM_EVAL_LEDToggle(LED4);
    Delay(100);
#endif
	}
}

#if defined(STM32F30X)
	void InitPeripheralDevices()
	{
		RCC_ClocksTypeDef rcc;
    
    /* Get the configured clock frequencies */
		RCC_GetClocksFreq(&rcc);
    
    /* Setup the SysTick timer */
		SysTick_Config(rcc.HCLK_Frequency / 1000);
		
    /* Initialize the LEDs on the discovery board */
		STM_EVAL_LEDInit(LED3);
		STM_EVAL_LEDInit(LED4);
		STM_EVAL_LEDInit(LED5);
		STM_EVAL_LEDInit(LED6);
		STM_EVAL_LEDInit(LED7);
		STM_EVAL_LEDInit(LED8);
		STM_EVAL_LEDInit(LED9);
		STM_EVAL_LEDInit(LED10);
	}
#elif defined(STM32F10X_MD_VL)
	void InitPeripheralDevices()
	{
		RCC_ClocksTypeDef rcc;
    
    /* Get the configured clock frequencies */
		RCC_GetClocksFreq(&rcc);
		SysTick_Config(rcc.HCLK_Frequency / 1000);
    
		/* Initialize peripheral clocks, etc */
		RCC_APB1PeriphClockCmd(RCC_APB1Periph_PWR, ENABLE);

		STM32vldiscovery_LEDInit(LED3);
		STM32vldiscovery_LEDInit(LED4);
	}
#elif defined(STM32F429_439xx)
	void InitPeripheralDevices()
	{
		RCC_ClocksTypeDef rcc;
    
    /* Get the configured clock frequencies */
		RCC_GetClocksFreq(&rcc);
    
    /* Setup the SysTick timer */
		SysTick_Config(rcc.HCLK_Frequency / 1000);
		
    /* Initialize the LEDs on the discovery board */
		
		STM_EVAL_LEDInit(LED3);
		STM_EVAL_LEDInit(LED4);
	}
#endif

void debugMessage(char* msg)
{
	while (*msg != 0)
	{
		ITM_SendChar(*msg);
		msg++;
	}
}

/*
__attribute__((naked))
void HardFault_Handler()
{
	static char msg[80];
	
	while (1) asm("nop");
}

__attribute__((naked))
void BusFault_Handler()
{
	volatile static uint32_t* CFSR = 0xE000ED28;
	
	asm("BKPT #0");
} // */
