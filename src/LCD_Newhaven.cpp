#include <LCD/Newhaven.hpp>

#include "STM32F10x.h"
#include "STM32f10x_GPIO.h"
#include "STM32f10x_EXTI.h"
#include "STM32f10x_I2C.h"

extern "C" void delay(uint32_t num_100us);

namespace STM32
{
	NewhavenLCD::NewhavenLCD(uint32_t I2Cline)
	{
		//! @todo Figure out how to use I2C2
		GPIO_InitTypeDef gpioInit;
		I2C_InitTypeDef i2cInit;
		
		gpioInit.GPIO_Pin = GPIO_Pin_6 | GPIO_Pin_7;
		gpioInit.GPIO_Speed = GPIO_Speed_50MHz;
		gpioInit.GPIO_Mode = GPIO_Mode_AF_OD;
		GPIO_Init(GPIOB, &gpioInit);
		
		I2C_Cmd(I2C1, ENABLE);
		
		i2cInit.I2C_Mode = I2C_Mode_I2C;
		i2cInit.I2C_DutyCycle = I2C_DutyCycle_2;
		i2cInit.I2C_Ack = I2C_Ack_Enable;
		i2cInit.I2C_AcknowledgedAddress = I2C_AcknowledgedAddress_7bit;
		i2cInit.I2C_ClockSpeed = 100000;
		i2cInit.I2C_OwnAddress1 = 0;
		
		I2C_Init(I2C1, &i2cInit);	
		
		this->privateData = (void*)I2C1;
	}
	
	void NewhavenLCD::GenerateStart()
	{
		I2C_GenerateSTART((I2C_Typedef*)privateData, ENABLE);
		WaitForEvent(I2C_EVENT_MASTER_MODE_SELECT);
	}
	
	void NewhavenLCD::GenerateStop()
	{
		I2C_GenerateSTOP((I2C_Typedef*)privateData, ENABLE);
	}
	
	void NewhavenLCD::WriteCharacterAtCursor(uint8_t data)
	{
		RawSendDataAndWaitForEvent(data, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		delay(1);
	}
	
	void NewhavenLCD::EnableDisplay()
	{
		RawSendDataAndWaitForEvent(0xFE, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		RawSendDataAndWaitForEvent(0x41, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		delay(1);
	}
	
	void NewhavenLCD::DisableDisplay()
	{
		RawSendDataAndWaitForEvent(0xFE, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		RawSendDataAndWaitForEvent(0x42, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		delay(1);
	}
	
	void NewhavenLCD::EnableUnderlineCursor()
	{
		RawSendDataAndWaitForEvent(0xFE, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		RawSendDataAndWaitForEvent(0x47, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		delay(1);
	}
	
	void NewhavenLCD::DisableUnderlineCursor()
	{
		RawSendDataAndWaitForEvent(0xFE, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		RawSendDataAndWaitForEvent(0x48, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		delay(1);
	}
	
	void NewhavenLCD::EnableBlinkingCursor()
	{
		RawSendDataAndWaitForEvent(0xFE, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		RawSendDataAndWaitForEvent(0x4b, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		delay(1);
	}
	
	void NewhavenLCD::DisableBlinkingCursor()
	{
		RawSendDataAndWaitForEvent(0xFE, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		RawSendDataAndWaitForEvent(0x4c, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		delay(1);
	}
	
	void NewhavenLCD::ResetCursorPosition()
	{
		RawSendDataAndWaitForEvent(0xFE, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		RawSendDataAndWaitForEvent(0x46, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		delay(15);
	}
	
	void NewhavenLCD::ClearScreen()
	{
		RawSendDataAndWaitForEvent(0xFE, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		RawSendDataAndWaitForEvent(0x46, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		delay(15);
	}
	
	void NewhavenLCD::MoveCursor(uint32 row, uint32_t column)
	{
		RawSendDataAndWaitForEvent(0xFE, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		RawSendDataAndWaitForEvent(0x45, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		RawSendDataAndWaitForEvent((row != 0 ? 0x40 : 0x00) | (0x0f & column),
			I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		delay(15);
	}
	
	void NewhavenLCD::MoveCursorLeft()
	{
		RawSendDataAndWaitForEvent(0xFE, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		RawSendDataAndWaitForEvent(0x49, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		delay(1);
	}
	
	void NewhavenLCD::MoveCursorRight()
	{
		RawSendDataAndWaitForEvent(0xFE, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		RawSendDataAndWaitForEvent(0x4a, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		delay(1);
	}
	
	void NewhavenLCD::MoveCursorLeftAndDelete()
	{
		RawSendDataAndWaitForEvent(0xFE, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		RawSendDataAndWaitForEvent(0x4e, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		delay(1);
	}
	
	void NewhavenLCD::MoveDisplayLeft()
	{
		RawSendDataAndWaitForEvent(0xFE, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		RawSendDataAndWaitForEvent(0x55, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		delay(1);
	}
	
	void NewhavenLCD::MoveDisplayRight()
	{
		RawSendDataAndWaitForEvent(0xFE, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		RawSendDataAndWaitForEvent(0x56, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		delay(1);
	}
	
	void NewhavenLCD::SetScreenContrast(uint8_t value)
	{
		RawSendDataAndWaitForEvent(0xFE, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		RawSendDataAndWaitForEvent(0x52, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		RawSendDataAndWaitForEvent(value, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		delay(5);
	}
	
	void NewhavenLCD::SetBacklightBrightness(uint8_t value)
	{
		RawSendDataAndWaitForEvent(0xFE, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		RawSendDataAndWaitForEvent(0x53, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		RawSendDataAndWaitForEvent(value, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		delay(1);
	}
	
	void NewhavenLCD::LoadCustomCharacter(CustomCharacter character)
	{
		RawSendDataAndWaitForEvent(0xFE, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		RawSendDataAndWaitForEvent(0x54, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		RawSendDataAndWaitForEvent(value, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		delay(2);
	}
	
	void NewhavenLCD::ChangeRS232BaudRate(uint8_t value)
	{
		RawSendDataAndWaitForEvent(0xFE, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		RawSendDataAndWaitForEvent(0x61, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		RawSendDataAndWaitForEvent(value, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		delay(30);
	}
	
	void NewhavenLCD::ChangeI2CAddress(uint8_t value)
	{
		RawSendDataAndWaitForEvent(0xFE, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		RawSendDataAndWaitForEvent(0x62, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		RawSendDataAndWaitForEvent(value, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		delay(30);
	}
	
	void NewhavenLCD::DisplayFirmwareInformation()
	{
		RawSendDataAndWaitForEvent(0xFE, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		RawSendDataAndWaitForEvent(0x70, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		delay(40);
	}
	
	void NewhavenLCD::DisplayRS232Info()
	{
		RawSendDataAndWaitForEvent(0xFE, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		RawSendDataAndWaitForEvent(0x71, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		delay(100);
	}
	
	void NewhavenLCD::DisplayI2CInfo()
	{
		RawSendDataAndWaitForEvent(0xFE, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		RawSendDataAndWaitForEvent(0x72, I2C_EVENT_MASTER_BYTE_TRANSMITTED);
		delay(40);
	}
	
	void NewhavenLCD::WaitForEvent(uint32_t eventID)
	{
		while (!I2C_CheckEvent((I2C_Typedef*)privateData, eventID));
	}
	
	void NewhavenLCD::RawSendData(uint8_t data)
	{
		I2C_SendData((I2C_Typedef*)privateData, data);
	}
	
	void NewhavenLCD::RawSendDataAndWaitForEvent(uint8_t data, uint32_t eventID)
	{
		RawSendData(data);
		WaitForEvent(eventID);
	}
}