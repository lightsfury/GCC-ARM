/*
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
*/

ENTRY(Reset_Handler);

_ramStart   = ORIGIN(RAM);
_ramEnd     = _ramStart + LENGTH(RAM);
_stackStart = _ramEnd;

SECTIONS
{
	.isr_vector   :
	{
		KEEP(*(.isr_vector))
	} > FLASH
	
	.text         :
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
	
	.ARM.extab    :
	{
		*(.ARM.extab* .gnu.linkonce.armextab.*)
	} > FLASH
	
	.ARM.exidx    :
	{
		*(.ARM.exidx* .gnu.linkonce.armexidx.*)
	} > FLASH
	
	. = ALIGN(4);
	_staticDataSource = .;
	
	/* Static non-zero init data */
	.data         : AT(_staticDataSource)
	{
		*(.data)
		*(.data.*)
	} > RAM
	
	_staticDataStart  = ADDR(.data);
	_staticDataLength = SIZEOF(.data);
	
	/* Static zero init data */
	.bss BLOCK(4) :
	{
		*(.bss)
		*(.bss.*)
		*(COMMON)
	} > RAM
	
	_staticZeroStart = ADDR(.bss);
	_staticZeroLength = SIZEOF(.bss);
	PROVIDE(end = _staticZeroStart + _staticZeroLength);
	
	.gdb_index    :
	{
		*(.gdb_index)
	}
	
	/** @section Debugging section-inception **/
	.debug				0	: { *(.debug) }
	.line				0	: { *(.line) }
	.debug_srcinfo		0	: { *(.debug_srcinfo) }
	.debug_sfnames		0	: { *(.debug_sfnames) }
	.debug_aranges		0	: { *(.debug_aranges) }
	.debug_pubnames		0	: { *(.debug_pubnames) }
	.debug_info			0	: { *(.debug_info) }
	.debug_abbrev		0	: { *(.debug_abbrev) }
	.debug_line			0	: { *(.debug_line) }
	.debug_frame		0	: { *(.debug_frame) }
	.debug_str			0	: { *(.debug_str) }
	.debug_loc			0	: { *(.debug_loc) }
	.debug_macinfo		0	: { *(.debug_macinfo) }
	.debug_weaknames	0	: { *(.debug_weaknames) }
	.debug_funcnames	0	: { *(.debug_funcnames) }
	.debug_typenames	0	: { *(.debug_typenames) }
	.debug_varnames		0	: { *(.debug_varnames) }
}
