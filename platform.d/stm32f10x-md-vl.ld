ENTRY(Reset_Handler)

MEMORY
{
	RAM		(rwx)	:	ORIGIN = 0x20000000, LENGTH = 8K
	FLASH	(rx)	:	ORIGIN = 0x08000000, LENGTH = 128K
}

_ramStart = ORIGIN(RAM);
_ramEnd = _ramStart + LENGTH(RAM);
_stackStart = _ramEnd;

SECTIONS
{
	.isr_vector	:
	{
		KEEP(*(.isr_vector))
	} > FLASH
	
	.text		:
	{
		*(.text)
		*(.text.*)
		*(.rodata)
		*(.rodata.*)
		*(.glue_7)
		*(.glue_7t)
		*(.vfp11_veneer)
		*(.v4_bx)
		*(.ARM.extab* .gnu.linkonce.armextab.*)
	} > FLASH
	
	.ARM.extab	:
	{
		*(.ARM.extab* .gnu.linkonce.armextab.*)
	} > FLASH
	
	.ARM.exidx	:
	{
		*(.ARM.exidx* .gnu.linkonc.armexidx.*)
	} > FLASH
	
	. = ALIGN(4);
	_staticDataInit = .;
	
	/* Static non-zero init data */
	.data	:	AT(_staticDataInit)
	{
		*(.data)
		*(.data.*)
	} > RAM
	
	_staticDataAddr = ADDR(.data);
	_staticDataLength = SIZEOF(.data);
	
	/* Static zero init data */
	.bss BLOCK(4)	:
	{
		*(.bss)
		*(.bss.*)
		*(COMMON)
	} > RAM
	
	_staticZeroAddr = ADDR(.bss);
	_staticZeroLength = SIZEOF(.bss);
}
