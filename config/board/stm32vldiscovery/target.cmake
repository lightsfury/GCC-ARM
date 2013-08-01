message(STATUS "Loading built-in configuration for STM32vldiscovery boards")

# Boiler-plate includes
include(GCCARMParseDebugLevel)
include(GCCARMBuildFileList)

#! @section Generic vendor/discovery line options

# Board specific options
option(STM_USE_PERIPH_DRIVERS "Use the STM peripheral driver library." ON)
option(STM_INCLUDE_DISCOVERY_FILES "Include the STM discovery driver files." ON)
set(STM_PERIPH_DRIVER_PATH "" CACHE PATH "Path to the STM peripheral driver library (aka firmware).")
set(STM_PERIPH_DRIVER_FILES "" CACHE STRING "List of peripheral drivers to use. Please seperate files with semicolons.")
option(STM_USE_SYSTEM_INIT "Instruct the boot script to call the CMSIS SystemInit function at boot time.\nThis function normally configures the programmable clock frequencies." ON)

set(STM_ALL_PERIPH_DRIVERS
	ADC
	BKP
	CAN
	CEC
	CRC
	DAC
	DBGMCU
	DMA
	EXTI
	FLASH
	DSMC
	GPIO
	I2C
	IWDG
	PWR
	RCC
	RTC
	SDIO
	SPI
	TIM
	USART
	WWDG)

set(OPENOCD_CONFIG_TARGETS "-fboard/stm32vldiscovery.cfg")

set(CPU_TYPE "cortex-m3")
set(CODE_TYPE "thumb")
set(CPU_FLOAT_ABI "soft")

set(VENDOR_C_FLAGS -DSTM32F10X_MD_VL)
set(VENDOR_CXX_FLAGS -DSTM32F10X_MD_VL)

set(VENDOR_LINK_SCRIPT "config/board/stm32vldiscovery/link.ld")
set(VENDOR_ISR_VECTOR  "config/vendor/ST/STM32F10x/isr_vector.c")
set(VENDOR_OPENOCD_SCRIPT "config/board/stm32vldiscovery/openocd.cfg")

if(STM_USE_PERIPH_DRIVERS)
	set(VENDOR_C_FLAGS "${VENDOR_C_FLAGS} \"-DUSE_STDPERIPH_DRIVER\"")
	set(VENDOR_CXX_FLAGS "${VENDOR_CXX_FLAGS} \"-DUSE_STDPERIPH_DRIVER\"")
	
	include_directories(
		"${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F10x_StdPeriph_Driver/inc"
		"${STM_PERIPH_DRIVER_PATH}/Libraries/CMSIS/CM3/CoreSupport"
		"${STM_PERIPH_DRIVER_PATH}/Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x"
		"${CMAKE_SOURCE_DIR}/config/board/stm32vldiscovery/include")
	
	set(_STM_PERIPH_FILES "${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F10x_StdPeriph_Driver/src/misc")
	AddToFileList(_STM_PERIPH_FILES
		"${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_"
		""
		FILES ${STM_PERIPH_DRIVER_FILES}
		VALIDATE ${STM_ALL_PERIPH_DRIVERS})
	
	AddToFileList(_STM_PERIPH_FILES
		"${STM_PERIPH_DRIVER_PATH}/Libraries/CMSIS/CM3/"
		""
		FILES
			"CoreSupport/core_cm3"
			"DeviceSupport/ST/STM32F10x/stm32f10x"
			"DeviceSupport/ST/STM32F10x/system_stm32f10x")
	
	if(STM_INCLUDE_DISCOVERY_FILES)
		set(VENDOR_C_FLAGS "${VENDOR_C_FLAGS} \"-DUSE_STM_DISCOVERY_FILES\"")
		set(VENDOR_CXX_FLAGS "${VENDOR_CXX_FLAGS} \"-DUSE_STM_DISCOVERY_FILES\"")
		include_directories("${STM_PERIPH_DRIVER_PATH}/Utilities")
		
		AddToFileList(_STM_PERIPH_FILES
			"${STM_PERIPH_DRIVER_PATH}/Utilities/"
			""
			FILES "STM32vldiscovery")
	endif()
	
	add_library(STM32vlFirmware STATIC "${CMAKE_SOURCE_DIR}/config/board/stm32vldiscovery/src/libSTMFirmware" ${_STM_PERIPH_FILES})
	
	set(VENDOR_FIRMWARE_TARGET STM32vlFirmware)
endif()
