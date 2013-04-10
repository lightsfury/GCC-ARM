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
_DEBUG_COMPILER_FLAGS	= -O2
_DEBUG_LINKER_FLAGS		=
endif

_TARGET_COMPILER_FLAGS	= -mthumb -mcpu=cortex-m3 $(_DEBUG_COMPILER_FLAGS) -DUSE_STDPERIPH_DRIVER -DSTM32F10X_MD_VL
_TARGET_LINKER_FLAGS	= -mthumb -mcpu=cortex-m3 -T./platform.d/stm32f10x-md-vl.ld $(_DEBUG_LINKER_FLAGS) -nostartfiles

#! @todo Add STM peripheral driver/CMSIS paths
# The user provides STM_PERIPH_DRIVER_PATH, which points to the root folder of the firmware package.
# The root folder is that folder which contains the Libraries, Project and Utilities folders.
_TARGET_CMSIS_CORE_PATH = $(STM_PERIPH_DRIVER_PATH)Libraries/CMSIS/CM3/CoreSupport/
_TARGET_CMSIS_STM_PATH	= $(STM_PERIPH_DRIVER_PATH)Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x/
_TARGET_STM_PERIPH_PATH	= $(STM_PERIPH_DRIVER_PATH)Libraries/STM32F10x_StdPeriph_Driver/
_TARGET_CORE_FILES		= $(_TARGET_CMSIS_CORE_PATH)core_cm3.c $(_TARGET_CMSIS_STM_PATH)system_stm32f10x.c $(_TARGET_STM_PERIPH_PATH)src/misc.c $(patsubst %,$(_TARGET_STM_PERIPH_PATH)src/stm32f10x_%.c, $(STM_PERIPH_DRIVER_FILES)) ./platform.d/boot_stm32f10x-md-vl.c
_TARGET_INCLUDE_PATH	= $(_TARGET_CMSIS_CORE_PATH) $(_TARGET_CMSIS_STM_PATH) $(_TARGET_STM_PERIPH_PATH)inc/
_TARGET_LIBRARY_PATH	=
_TARGET_PLATFORM_FILES	= ./platform.d/stm32f10x-md-vl.ld ./platform.d/boot_stm32f10x-md-vl.c

ifeq ($(STM_DISCOVERY_FILES),1)
_TARGET_CORE_FILES		+= $(STM_PERIPH_DRIVER_PATH)Utilities/STM32vldiscovery.c 
_TARGET_INCLUDE_PATH	+=  $(STM_PERIPH_DRIVER_PATH)Utilities/
endif
