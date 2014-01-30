#include <STM32F4XX.h>
#include <stm32f429i_discovery.h>

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
    /* Toggle the LEDs in 100ms steps */
    STM_EVAL_LEDToggle(LED3);
    Delay(100);
    STM_EVAL_LEDToggle(LED4);
    Delay(100);
	}
}

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
