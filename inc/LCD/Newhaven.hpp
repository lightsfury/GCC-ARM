#ifndef _EECE_337_STM32_LIB_LCD_NEWHAVEN_HPP_
#define _EECE_337_STM32_LIB_LCD_NEWHAVEN_HPP_

#include <stdint.h>

#ifndef ENUM_CLASS
	#ifdef __CXX_HAVE_ENUM_CLASS__
		#define ENUM_CLASS(name, type, ...)     \
			enum class name : type { __VA_ARGS__ }
	#else
		#define ENUM_CLASS(name, type, ...)       \
			struct name {                         \
			enum _internal_enum {                 \
				__VA_ARGS__ };                    \
			type _internal_value;                 \
			operator type() {                     \
				return (type)(_internal_value); } \
			name() {}                             \
			name(type t):_internal_value((_internal_enum)t){} \
			name(_internal_enum t) : _internal_value(t) {} \
			name operator=(const type t) { _internal_value=t; return *this; } \
			name operator=(const _internal_enum t) { _internal_value = (type)t; return *this; } \
		}
	#endif
#endif

namespace STM32
{
	ENUM_CLASS(I2CLineID, uint32_t,
		Line1 = 0x00,
		Line2 = 0x40
	);
	
	struct CustomCharacter
	{
		uint8_t VirtualAddress;
		uint8_t Bitmap[8];
	};

	class NewhavenLCD
	{
	public:
		NewhavenLCD(uint32_t I2Cline);
		~NewhavenLCD();
		
		void GenerateStart();
		void GenerateStop();
	
		void WriteCharacterAtCursor(uint8_t character);
		void EnableDisplay();
		void DisableDisplay();
		void EnableUnderlineCursor();
		void DisableUnderlineCursor();
		void EnableBlinkingCursor();
		void DisableBlinkingCursor();
		void ResetCursorPosition();
		
		void ClearScreen();
		void MoveCursor(uint32_t row, uint32_t column);
		void MoveCursorLeft();
		void MoveCursorRight();
		void MoveCursorLeftAndDelete();
		
		void MoveDisplayLeft();
		void MoveDisplayRight();
		
		void SetScreenContrast(uint8_t);
		void SetBacklightBrightness(uint8_t);
		//! @todo Define CustomCharacter object
		void LoadCustomCharacter(CustomCharacter);
		
		void ChangeRS232BaudRate(uint8_t);
		void ChangeI2CAddress(uint8_t);
		
		void DisplayFirmwareInformation();
		void DisplayRS232Info();
		void DisplayI2CInfo();
	private:
		void WaitForEvent(uint32_t);
		void RawSendData(uint8_t);
		void RawSendDataAndWaitForEvent(uint8_t data, uint32_t event);
	
		void* privateData;
	};
}


#endif // _EECE_337_STM32_LIB_LCD_NEWHAVEN_HPP_
