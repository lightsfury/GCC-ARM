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

#include <stm32f10x.h>
#include <stm32f10x_conf.h>
#include <STM32vldiscovery.h>
#include <stm32f10x_gpio.h>
#include <stm32f10x_i2c.h>
#include <stm32f10x_tim.h>

#include <stdint.h>
#include <string.h>
#include <stdio.h>

__IO uint32_t TickCount = 0x00;

void LCD_WriteLines(const char*, const char*);
void LCD_SetContrast(int);
void LCD_SetBacklight(int);
void LCD_ClearScreen();
void LCD_ShiftScreenLeft();
void LCD_ShiftScreenRight();

int main()
{
	const char* line1 = "Hit button to start";
	const char* line2 = "Button not yet implemented";
	
	InitPeripheralDevices();
	
	STM32vldiscovery_LEDOff(LED3);
	STM32vldiscovery_LEDOff(LED4);
	
	LCD_ClearScreen();
	
	LCD_WriteLines(line1, line2);
	Delay(1000);
	
	while (1)
	{
		if (TickCount % 750 == 0)
		{
			LCD_ShiftScreenLeft();
			Delay(5);
		}
	}
	
	return 1;
}

void TIM2_IRQHandler()
{
	if (TIM_GetITStatus(TIM2, TIM_IT_Update) != RESET)
	{
		TickCount++;
		
		TIM_ClearITPendingBit(TIM2, TIM_IT_Update);
	}
}

void InitPeripheralDevices()
{
	uint32_t lseDelay = 0;
	GPIO_InitTypeDef gpio;
	I2C_InitTypeDef i2c;
	NVIC_InitTypeDef nvic;
	TIM_TimeBaseInitTypeDef timer;
	/* Initialize peripheral clocks, GPIO ports, etc */
	RCC_APB1PeriphClockCmd(RCC_APB1Periph_PWR, ENABLE);
	
	STM32vldiscovery_LEDInit(LED3);
	STM32vldiscovery_LEDInit(LED4);
	
	STM32vldiscovery_LEDOff(LED3);
	STM32vldiscovery_LEDOff(LED4);
	
	STM32vldiscovery_PBInit(BUTTON_USER, BUTTON_MODE_GPIO);
	
	// Initialize the SysTick timer to 1kHz
	if (SysTick_Config(SystemCoreClock / 1000))
	{
		while (1);
	}
	
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
	
	/* Setup the I2C line */
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB, ENABLE);
	RCC_APB1PeriphClockCmd(RCC_APB1Periph_I2C1, ENABLE);
	
	gpio.GPIO_Pin = GPIO_Pin_6 | GPIO_Pin_7;
	gpio.GPIO_Speed = GPIO_Speed_50MHz;
	gpio.GPIO_Mode = GPIO_Mode_AF_OD;
	GPIO_Init(GPIOB, &gpio);
	
	I2C_Cmd(I2C1, ENABLE);
	
	i2c.I2C_Mode = I2C_Mode_I2C;
	i2c.I2C_DutyCycle = I2C_DutyCycle_2;
	i2c.I2C_Ack = I2C_Ack_Enable;
	i2c.I2C_AcknowledgedAddress = I2C_AcknowledgedAddress_7bit;
	i2c.I2C_ClockSpeed = 100000;
	i2c.I2C_OwnAddress1 = 0;
	
	I2C_Init(I2C1, &i2c);
	
	/* Setup the timers */
	RCC_APB1PeriphClockCmd(RCC_APB1Periph_TIM2, ENABLE);
	/* Setup the timer interupt */
	nvic.NVIC_IRQChannel = TIM2_IRQn;
	nvic.NVIC_IRQChannelPreemptionPriority = 0;
	nvic.NVIC_IRQChannelSubPriority = 1;
	nvic.NVIC_IRQChannelCmd = ENABLE;
	
	NVIC_Init(&nvic);
	
	/* Setup the timer */
	timer.TIM_Period = 1000 - 1; // Scale 1MHz to 1kHz
	timer.TIM_Prescaler = 24 - 1; // Scale 24MHz to 1MHz
	timer.TIM_ClockDivision = 0;
	timer.TIM_CounterMode = TIM_CounterMode_Up;
	
	TIM_TimeBaseInit(TIM2, &timer);
	
	/* Enable the update ISR */
	TIM_ITConfig(TIM2, TIM_IT_Update, ENABLE);
	
	TIM_Cmd(TIM2, ENABLE);
	
	/* Set the button ISR to maximum priority */
	NVIC_SetPriority(USER_BUTTON_EXTI_IRQn,
		NVIC_EncodePriority(NVIC_GetPriorityGrouping(), 0, 0));
}

/* Library code */
int LCD_TryStartup()
{
	I2C_GenerateSTART(I2C1, ENABLE);
	while (!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_MODE_SELECT));
	return 0x01;
}

void LCD_WriteLines(const char* line1, const char* line2)
{
	const char* ptr;
	if (LCD_TryStartup())
	{
		STM32vldiscovery_LEDOn(LED3);
		
		I2C_Send7bitAddress(I2C1, 0x50, I2C_Direction_Transmitter);
		while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED));
		Delay(1);
		
		I2C_SendData(I2C1, 0xFE);
		while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_BYTE_TRANSMITTED));
		Delay(1);
		
		I2C_SendData(I2C1, 0x46);
		while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_BYTE_TRANSMITTED));
		Delay(1);

		if (line1 != NULL)
		{
			for (ptr = line1; *ptr != 0; ptr++)
			{
				I2C_SendData(I2C1, *ptr);
				while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_BYTE_TRANSMITTED));
				Delay(1);
			}
		}
		
		// Move Cursor to second line
		I2C_SendData(I2C1, 0xFE);
		while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_BYTE_TRANSMITTED));
		I2C_SendData(I2C1, 0x45);
		while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_BYTE_TRANSMITTED));
		I2C_SendData(I2C1, 0x40);
		while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_BYTE_TRANSMITTED));
		Delay(1);
		
		if (line2 != NULL)
		{
			for (ptr = line2; *ptr != 0; ptr++)
			{
				I2C_SendData(I2C1, *ptr);
				while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_BYTE_TRANSMITTED));
				Delay(1);
			}
		}
		
		I2C_GenerateSTOP(I2C1, ENABLE);
		
		STM32vldiscovery_LEDOff(LED3);
	}
}

void LCD_SetContrast(int level)
{
	if (LCD_TryStartup())
	{
		I2C_Send7bitAddress(I2C1, 0x50, I2C_Direction_Transmitter);
		while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED));

		// Set contrast - input level should be 1..50
		I2C_SendData(I2C1, 0xFE);
		while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_BYTE_TRANSMITTED));  
		I2C_SendData(I2C1, 0x52);
		while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_BYTE_TRANSMITTED));
		I2C_SendData(I2C1, level);
		while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_BYTE_TRANSMITTED));

		Delay(2);
		I2C_GenerateSTOP(I2C1, ENABLE);
	}
}         

void LCD_SetBacklight(int level)
{
	if (LCD_TryStartup())
	{
		I2C_Send7bitAddress(I2C1, 0x50, I2C_Direction_Transmitter);
		while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED));

		// Set backlight - input level should be 1..8
		I2C_SendData(I2C1, 0xFE);
		while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_BYTE_TRANSMITTED));  
		I2C_SendData(I2C1, 0x53);
		while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_BYTE_TRANSMITTED));
		I2C_SendData(I2C1, level);
		while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_BYTE_TRANSMITTED));

		Delay(2);
		I2C_GenerateSTOP(I2C1, ENABLE);
	}
}         

void LCD_ClearScreen()
{
	if (LCD_TryStartup())
	{
		I2C_Send7bitAddress(I2C1, 0x50, I2C_Direction_Transmitter);
		while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED));

		// Clear Screen 
		I2C_SendData(I2C1, 0xFE);
		while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_BYTE_TRANSMITTED));  
		I2C_SendData(I2C1, 0x51);
		while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_BYTE_TRANSMITTED));

		Delay(2);
		I2C_GenerateSTOP(I2C1, ENABLE);
	}
}

void LCD_ShiftScreenLeft()
{
	if (LCD_TryStartup())
	{
		I2C_Send7bitAddress(I2C1, 0x50, I2C_Direction_Transmitter);
		while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED));

		// Command sentinel
		I2C_SendData(I2C1, 0xFE);
		while (!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_BYTE_TRANSMITTED));
		// Move screen left
		I2C_SendData(I2C1, 0x55);
		while (!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_BYTE_TRANSMITTED));
		Delay(1);
		I2C_GenerateSTOP(I2C1, ENABLE);
	}
}

void LCD_ShiftScreenRight()
{
	if (LCD_TryStartup())
	{
		I2C_Send7bitAddress(I2C1, 0x50, I2C_Direction_Transmitter);
		while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED));

		// Command sentinel
		I2C_SendData(I2C1, 0xFE);
		while (!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_BYTE_TRANSMITTED));
		// Move screen left
		I2C_SendData(I2C1, 0x56);
		while (!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_BYTE_TRANSMITTED));
		Delay(1);
		I2C_GenerateSTOP(I2C1, ENABLE);
	}
}

#ifdef USE_FULL_ASSERT

void assert_failed(uint8_t* file, uint32_t lineNumber)
{
	while (1) /* no-op loop */;
}

#endif
