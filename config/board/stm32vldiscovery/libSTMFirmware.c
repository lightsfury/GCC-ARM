#include <STM32F10x_conf.h>

void assert_failed(uint8_t* file, uint32_t lineNumber)
{
	while (1)
	{
		/** Intentional no-op loop **/
		asm("nop");
	}
}