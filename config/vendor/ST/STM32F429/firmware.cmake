message(STATUS "Loading configuration for STM32F34xx Peripheral Firmware")

set(STM_PERIPH_DRIVER_PATH "" CACHE PATH "Path to the STM peripheral driver library (aka firmware).")
option(STM_USE_PERIPH_DRIVER "Use the STM32F429 peripheral driver library." ON)
option(STM_USE_SYSTEM_INIT "Instruct the boot script to call the CMSIS SystemInit function at boot time.\nThis function normally configures the programmable clock frequencies." ON)
option(STM_USE_USB_DRIVER "Use the STM USB driver library." ON)

set(STM_PERIPH_DRIVER_FILES
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_adc.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_can.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_crc.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_cryp.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_cryp_aes.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_cryp_des.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_cryp_tdes.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dac.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dbgmcu.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dcmi.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dma.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dma2d.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_exti.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_flash.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_fmc.c
  # The STM32F4x9 no longer supports FSMC, FMC is recommended as a replacement
	#${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_fsmc.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_gpio.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_hash.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_hash_md5.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_hash_sha1.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_i2c.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_iwdg.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_ltdc.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_pwr.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_rcc.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_rng.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_rtc.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_sai.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_sdio.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_spi.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_syscfg.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_tim.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_usart.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_wwdg.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F4xx_StdPeriph_Driver/src/misc.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/CMSIS/Device/ST/STM32F4xx/Source/Templates/system_stm32f4xx.c
	${CMAKE_SOURCE_DIR}/config/vendor/ST/firmware/libSTMFirmware.c)

set(STM_USB_DRIVER_FILES
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32_USB_Device_Library/src/usb_init.c
  )

if(STM_USE_PERIPH_DRIVER)
  add_definitions(-DUSE_STDPERIPH_DRIVER)
	
	include_directories(
		"${STM_PERIPH_DRIVER_PATH}/Libraries/CMSIS/Include"
		"${STM_PERIPH_DRIVER_PATH}/Libraries/CMSIS/Device/ST/STM32F4xx/Include"
		"${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F4xx_StdPeriph_Driver/inc"
		"${CMAKE_SOURCE_DIR}/config/vendor/ST/firmware/include")
	
	add_library(STM32F429Firmware STATIC ${STM_PERIPH_DRIVER_FILES})
	
	set(VENDOR_FIRMWARE_TARGET STM32F429Firmware)
endif()

if(0) #STM_USE_USB_DRIVER)
  # The new USB device library is quite nice. It includes several device class
  # initializers. It doesn't seem to include a serial comm class definition.
  # This is disabled until I can figure out the USB driver layout & etc.
  add_definitions(-DSTM_USB_DRIVER)
	
	include_directories("${STM_PERIPH_DRIVER_PATH}/Libraries/STM32_USB_Device_Library/inc")

	add_library(STMUSBLibrary STATIC ${STM_USB_DRIVER_FILES})
	
	set(VENDOR_FIRMWARE_TARGET ${VENDOR_FIRMWARE_TARGET} STMUSBLibrary)
endif()
