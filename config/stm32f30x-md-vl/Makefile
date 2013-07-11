# Copyright (c) 2013 Robert Beam
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Are we building a debug binary?
ifeq ($(DEBUG_BUILD),1)
_DEBUG_COMPILER_FLAGS	= -g -gdwarf-2 -DUSE_FULL_ASSERT
_DEBUG_LINKER_FLAGS		= 
else
_DEBUG_COMPILER_FLAGS	= -Os
_DEBUG_LINKER_FLAGS		= -dead_strip
endif

_TARGET_COMPILER_FLAGS	= -mthumb -mcpu=cortex-m4 $(_DEBUG_COMPILER_FLAGS) -DSTM32F30X -DUSE_STDPERIPHER_DRIVER "-DDEVICE_CLASS=stm32f30x"
_TARGET_LINKER_FLAGS	= -mthumb -mcpu=cortex-m4 $(_DEBUG_LINKER_FLAGS) -T./platform.d/stm32f30x/linker.ld -nostartfiles

# The user provides STM_PERIPH_DRIVER_PATH, which points to the root folder of
# the firmware package. The root folder is that folder which contains the
# Libraries, Project and Utilities folders.
_CMSIS_CORE_BASE_PATH	= Libraries/CMSIS/Include/
_CMSIS_STM_BASE_PATH	= Libraries/CMSIS/Device/ST/STM32F30x/
_STM_PERIPH_BASE_PATH	= Libraries/STM32F30x_StdPeriph_Driver/
_CORE_FILES_BASE_PATH	= $(_CMSIS_STM_BASE_PATH)Source/Templates/system_stm32f30x.c $(patsubst %,$(_STM_PERIPH_BASE_PATH)src/stm32f30x_%.c, $(STM_PERIPH_DRIVER_FILES))

_TARGET_BUILD_PATH		= $(BUILD_PATH)STM_Firmware/

ifeq ($(STM_DISCOVERY_FILES),1)
_CORE_FILES_BASE_PATH	+= $(addprefix Utilities/STM32F3_Discovery/, stm32f3_discovery.c stm32f3_discovery_l3dg20.c stm32f3_discovery_lsm303dlhc.c)
_TARGET_COMPILER_FLAGS	+= -DSTM_DISCOVERY_FILES
endif

_TARGET_CORE_OBJECT_FILES	= $(realpath $(_CORE_FILES_BASE_PATH:%c=$(_TARGET_BUILD_PATH)%c-periph) $(BUILD_PATH)platform.d/stm32f30x/boot.c-o)

_TARGET_INCLUDE_PATH		= $(addprefix $(STM_PERIPH_DRIVER_PATH), $(_CMSIS_CORE_BASE_PATH) $(_CMSIS_STM_BASE_PATH) $(_STM_PERIPH_BASE_PATH)inc/)
_TARGET_LIBRARY_PATH		=
_TARGET_PLATFORM_FILES		= ./platform.d/stm32f10x-md-vl/linker.ld

ifeq ($(STM_DISCOVERY_FILES),1)
_TARGET_INCLUDE_PATH	+=  $(STM_PERIPH_DRIVER_PATH)Utilities/
endif

_REAL_TARGET_BUILD_PATH	= $(realpath $(_TARGET_BUILD_PATH))

.SECONDEXPANSION:
$(_REAL_TARGET_BUILD_PATH)%c-periph: $(STM_PERIPH_DRIVER_PATH)%c $$(@D)/.d
	$(C_COMPILER) -c $(C_FLAGS) $(INCLUDE_PATH) $< -o $@
