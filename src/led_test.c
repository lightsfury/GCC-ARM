#if defined(STM32F30X)
	#include <STM32F30X.h>
	#include <stm32f3_discovery.h>
#elif defined(STM32F10X_MD_VL)
	#include <STM32F10X.h>
	#include <stm32vldiscovery.h>
#else
	#error Did not detect a supported platform.
#endif

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
		STM32vldiscovery_LEDToggle(LED3);
		Delay(100);
		STM32vldiscovery_LEDToggle(LED4);
		Delay(100);
#endif
	}
}


#if defined(STM32F30X)
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
#elif defined(STM32F10X_MD_VL)
	void InitPeripheralDevices()
	{
		uint32_t lseDelay = 0;
		/* Initialize peripheral clocks, etc */
		RCC_APB1PeriphClockCmd(RCC_APB1Periph_PWR, ENABLE);

		STM32vldiscovery_LEDInit(LED3);
		STM32vldiscovery_LEDInit(LED4);

		STM32vldiscovery_LEDOff(LED3);
		STM32vldiscovery_LEDOff(LED4);

		STM32vldiscovery_PBInit(BUTTON_USER, BUTTON_MODE_GPIO);

		/* Initialize the SysTick timer to 1kHz */
		if (SysTick_Config(SystemCoreClock / 1000))
		{
			while (1);
		}

		/* Setup the low-speed external clock */
		PWR_BackupAccessCmd(ENABLE);
		RCC_LSEConfig(RCC_LSE_ON);

		while (1)
		{
			if (lseDelay < 0x08)
			{
				Delay(500);
				lseDelay += 0x01;
				if (RCC_GetFlagStatus(RCC_FLAG_LSERDY) != RESET)
				{
					lseDelay |= 0x100;
					STM32vldiscovery_LEDOff(LED4);
					RCC_LSEConfig(RCC_LSE_OFF);
					break;
				}
			}
			else
			{
				if (RCC_GetFlagStatus(RCC_FLAG_LSERDY) == RESET)
				{
					lseDelay |= 0x0f0;
					STM32vldiscovery_LEDOn(LED4);
				}
				RCC_LSEConfig(RCC_LSE_OFF);
				break;
			}
		}
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

void HardFault_Handler()
{
	static char msg[80];
	
	sprintf(msg, "  HKSR: 0x%08x\n", (unsigned int)(SCB->HFSR));
	debugMessage("HardFault_Handler");
	debugMessage(msg);
	
	while (1) asm("nop");
}
