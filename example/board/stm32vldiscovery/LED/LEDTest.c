#include <STM32F10X.h>
#include <stm32vldiscovery.h>

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
    /* Left-right toggle in 100ms steps */
		STM32vldiscovery_LEDToggle(LED3);
		Delay(250);
		STM32vldiscovery_LEDToggle(LED4);
		Delay(250);
	}
}

void InitPeripheralDevices()
{
  RCC_ClocksTypeDef rcc;
  
  /* Get the configured clock frequencies */
  RCC_GetClocksFreq(&rcc);
  
  /* Setup the SysTick timer */
  SysTick_Config(rcc.HCLK_Frequency / 1000);
  
  /* Initialize the LEDs */
  STM32vldiscovery_LEDInit(LED3);
  STM32vldiscovery_LEDInit(LED4);
}
