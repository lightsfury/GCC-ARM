message(STATUS "Loading configuration for STM32F30x Peripheral Firmware")

set(STM_PERIPH_DRIVER_PATH "" CACHE PATH "Path to the STM peripheral driver library (aka firmware).")
option(STM_USE_PERIPH_DRIVER "Use the STMF330x peripheral driver library." ON)
option(STM_USE_SYSTEM_INIT "Instruct the boot script to call the CMSIS SystemInit function at boot time.\nThis function normally configures the programmable clock frequencies." ON)
option(STM_USE_USB_DRIVER "Use the STM USB driver library." ON)

set(STM_PERIPH_DRIVER_FILES
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F30x_StdPeriph_Driver/src/stm32f30x_ADC.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F30x_StdPeriph_Driver/src/stm32f30x_CAN.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F30x_StdPeriph_Driver/src/stm32f30x_COMP.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F30x_StdPeriph_Driver/src/stm32f30x_CRC.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F30x_StdPeriph_Driver/src/stm32f30x_DAC.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F30x_StdPeriph_Driver/src/stm32f30x_DBGMCU.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F30x_StdPeriph_Driver/src/stm32f30x_DMA.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F30x_StdPeriph_Driver/src/stm32f30x_EXTI.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F30x_StdPeriph_Driver/src/stm32f30x_FLASH.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F30x_StdPeriph_Driver/src/stm32f30x_GPIO.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F30x_StdPeriph_Driver/src/stm32f30x_I2C.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F30x_StdPeriph_Driver/src/stm32f30x_IWDG.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F30x_StdPeriph_Driver/src/stm32f30x_MISC.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F30x_StdPeriph_Driver/src/stm32f30x_OPAMP.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F30x_StdPeriph_Driver/src/stm32f30x_PWR.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F30x_StdPeriph_Driver/src/stm32f30x_RCC.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F30x_StdPeriph_Driver/src/stm32f30x_RTC.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F30x_StdPeriph_Driver/src/stm32f30x_SPI.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F30x_StdPeriph_Driver/src/stm32f30x_SYSCFG.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F30x_StdPeriph_Driver/src/stm32f30x_TIM.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F30x_StdPeriph_Driver/src/stm32f30x_USART.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F30x_StdPeriph_Driver/src/stm32f30x_WWDG.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/CMSIS/Device/ST/STM32F30x/Source/Templates/system_stm32f30x.c
	${CMAKE_SOURCE_DIR}/config/vendor/ST/firmware/libSTMFirmware.c)

set(STM_USB_DRIVER_FILES
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32_USB-FS-Device_Driver/src/usb_init.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32_USB-FS-Device_Driver/src/usb_int.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32_USB-FS-Device_Driver/src/usb_mem.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32_USB-FS-Device_Driver/src/usb_regs.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32_USB-FS-Device_Driver/src/usb_sil.c)

if(STM_USE_PERIPH_DRIVER)
	set(VENDOR_C_FLAGS "${VENDOR_C_FLAGS} \"-DUSE_STDPERIPH_DRIVER\"")
	set(VENDOR_CXX_FLAGS "${VENDOR_CXX_FLAGS} \"-DUSE_STDPERIPH_DRIVER\"")
	
	include_directories(
		"${STM_PERIPH_DRIVER_PATH}/Libraries/CMSIS/Include"
		"${STM_PERIPH_DRIVER_PATH}/Libraries/CMSIS/Device/ST/STM32F30x/Include"
		"${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F30x_StdPeriph_Driver/inc"
		"${CMAKE_SOURCE_DIR}/config/vendor/ST/firmware/include")
	
	add_library(STM32F3Firmware STATIC ${STM_PERIPH_DRIVER_FILES})
	
	set(VENDOR_FIRMWARE_TARGET STM32F3Firmware)
endif()

if(STM_USE_USB_DRIVER)
	set(VENDOR_C_FLAGS "${VENDOR_C_FLAGS} \"-DSTM_USB_DRIVER\"")
	set(VENDOR_CXX_FLAGS "${VENDOR_CXX_FLAGS} \"-DSTM_USB_DRIVER\"")
	
	include_directories("${STM_PERIPH_DRIVER_PATH}/Libraries/STM32_USB-FS-Device_Driver/inc")

	add_library(STMUSBLibrary STATIC ${STM_USB_DRIVER_FILES})
	
	set(VENDOR_FIRMWARE_TARGET ${VENDOR_FIRMWARE_TARGET} STMUSBLibrary)
endif()
