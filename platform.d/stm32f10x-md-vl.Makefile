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
