#include <STM32f10x.h>
#include <stm32vldiscovery.h>

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
		STM32vldiscovery_LEDToggle(LED3);
		Delay(150);
		STM32vldiscovery_LEDToggle(LED4);
		Delay(350);
	}
}

void InitPeripheralDevices()
{
	uint32_t lseDelay = 0;
	GPIO_InitTypeDef gpio;
	/* Initialize peripheral clocks, GPIO ports, etc */
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