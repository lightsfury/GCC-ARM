#include <STM32f30x.h>
#include <stm32f3_discovery.h>

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
	}
}

void InitPeripheralDevices()
{
	RCC_ClocksTypeDef rcc;
	RCC_GetClocksFreq(&rcc);
	SysTick_Config(rcc.HCLK_Frequency / 1000);
	
	STM_EVAL_LEDInit(LED3);
	STM_EVAL_LEDInit(LED4);
	STM_EVAL_LEDInit(LED5);
	STM_EVAL_LEDInit(LED6);
	STM_EVAL_LEDInit(LED7);
	STM_EVAL_LEDInit(LED8);
	STM_EVAL_LEDInit(LED9);
	STM_EVAL_LEDInit(LED10);
}

#define DEFAULT_ISR(isr) void isr (void) { while (1) asm("nop"); }

void debugMessage(char* msg)
{
	while (*msg != 0)
	{
		ITM_SendChar(*msg);
		msg++;
	}
}

void HardFault_Handler()
{
	static char msg[80];
	
	sprintf(msg, "  HKSR: 0x%08x\n", SCB->HFSR);
	debugMessage("HardFault_Handler");
	debugMessage(msg);
	
	while (1) asm("nop");
}
