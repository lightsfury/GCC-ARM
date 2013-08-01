message(STATUS "Loading built-in configuration for STM32F3discovery boards.")

# Boiler-plate includes
include(GCCARMParseDebugLevel)
include(GCCARMBuildFileList)

# Board specific options
option(STM_USE_PERIPH_DRIVERS "Use the STM peripheral driver library." ON)
option(STM_INCLUDE_DISCOVERY_FILES "Include the STM discovery driver files." ON)
set(STM_PERIPH_DRIVER_PATH "" CACHE PATH "Path to the STM peripheral driver library (aka firmware).")
set(STM_PERIPH_DRIVER_FILES "" CACHE STRING "List of peripheral drivers to use. Please seperate files with semicolons.")
option(STM_USE_SYSTEM_INIT "Instruct the boot script to call the CMSIS SystemInit function at boot time.\nThis function normally configures the programmable clock frequencies." ON)
option(STM_INCLUDE_USB_DRIVERS "Use the STM USB driver library." ON)

set(STM_ALL_PERIPH_DRIVERS
	ADC
	CAN
	COMP
	CRC
	DAC
	DBGMCU
	DMA
	EXTI
	FLASH
	GPIO
	I2C
	IWDG
	MISC
	OPAMP
	PWR
	RCC
	RTC
	SPI
	SYSCFG
	TIM
	USART
	WWDG)

set(OPENOCD_CONFIG_TARGETS "-fboard/stm32f3discovery.cfg")

set(CPU_TYPE "cortex-m4")
set(CODE_TYPE "thumb")
set(CPU_FLOAT_ABI "hard")

set(VENDOR_C_FLAGS "-DSTM32F30X")
set(VENDER_CXX_FLAGS "-DSTM32F30X")

set(VENDOR_LINK_SCRIPT "config/board/stm32f3discovery/link.ld")
set(VENDOR_ISR_VECTOR "config/vendor/ST/STM32F30x/isr_vector.c")
set(VENDOR_OPENOCD_SCRIPT "config/board/stm32f3discovery/openocd.cfg")

if(STM_USE_PERIPH_DRIVERS)
	set(VENDOR_C_FLAGS "${VENDOR_C_FLAGS} \"-DUSE_STDPERIPH_DRIVER\"")
	set(VENDOR_CXX_FLAGS "${VENDOR_CXX_FLAGS} \"-DUSE_STDPERIPH_DRIVER\"")
	
	include_directories(
		"${STM_PERIPH_DRIVER_PATH}/Libraries/CMSIS/Include"
		"${STM_PERIPH_DRIVER_PATH}/Libraries/CMSIS/Device/ST/STM32F30x/Include"
		"${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F30x_StdPeriph_Driver/inc"
		"${CMAKE_SOURCE_DIR}/config/board/stm32f3discovery/include")
	
	BuildFileList(_STM_PERIPH_FILES
		"${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F30x_StdPeriph_Driver/src/stm32f30x_"
		""
		FILES ${STM_PERIPH_DRIVER_FILES}
		VALIDATE ${STM_ALL_PERIPH_DRIVERS})
	
	AddToFileList(_STM_PERIPH_FILES
		"${STM_PERIPH_DRIVER_PATH}/Libraries/CMSIS/Device/ST/STM32F30x/Source/Templates/"
		""
		FILES
			"system_stm32f30x")
	
	if(STM_INCLUDE_DISCOVERY_FILES)
		set(VENDOR_C_FLAGS "${VENDOR_C_FLAGS} \"-DUSE_STM_DISCOVERY_FILES\"")
		set(VENDOR_CXX_FLAGS "${VENDOR_CXX_FLAGS} \"-DUSE_STM_DISCOVERY_FILES\"")
		
		include_directories("${STM_PERIPH_DRIVER_PATH}/Utilities/STM32F3_Discovery")
		
		AddToFileList(_STM_PERIPH_FILES
			"${STM_PERIPH_DRIVER_PATH}/Utilities/STM32F3_Discovery/"
			""
			FILES
				"stm32f3_discovery"
				"stm32f3_discovery_l3gd20"
				"stm32f3_discovery_lsm303dlhc")
	endif()
	
	add_library(STM32F3Firmware STATIC "${CMAKE_SOURCE_DIR}/config/board/stm32f3discovery/src/libSTMFirmware" ${_STM_PERIPH_FILES})
	
	set(VENDOR_FIRMWARE_TARGET STM32F3Firmware)
endif()

if(STM_INCLUDE_USB_DRIVERS)
	set(VENDOR_C_FLAGS "${VENDOR_C_FLAGS} \"-DUSE_USB_DRIVER\"")
	set(VENDOR_CXX_FLAGS "${VENDOR_CXX_FLAGS} \"-DUSE_USB_DRIVER\"")
	
	include_directories("${STM_PERIPH_DRIVER_PATH}/Libraries/STM32_USB-FS-Device_Driver/inc")
	
	BuildFileList(_STM_USB_FILES "${STM_PERIPH_DRIVER_PATH}/Libraries/STM32_USB-FS-Device_Driver/src/usb_" ""
		FILES core init int mem regs sil)
	
	add_library(STMUSBLibrary STATIC  ${_STM_USB_FILES})
	
	set(VENDOR_FIRMWARE_TARGET ${VENDOR_FIRMWARE_TARGET} STMUSBLibrary)
	
endif()
