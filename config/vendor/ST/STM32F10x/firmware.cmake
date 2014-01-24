message(STATUS "Loading configuration for STM32F10x Peripheral Firmware")

set(STM_PERIPH_DRIVER_PATH "" CACHE PATH "Path to the STM peripheral driver library (aka firmware).")
option(STM_USE_PERIPH_DRIVER "Use the STM32F10x peripher driver library." ON)
option(STM_USE_SYSTEM_INIT "Instruct the boot script to call the CMSIS SystemInit function at boot time.\nThis function normally configures the programmable clock frequencies." ON)

set(STM_PERIPH_DRIVER_FILES
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_ADC.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_BKP.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_CAN.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_CEC.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_CRC.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_DAC.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_DBGMCU.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_DMA.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_EXTI.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_FLASH.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_FSMC.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_GPIO.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_I2C.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_IWDG.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_PWR.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_RCC.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_RTC.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_SDIO.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_SPI.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_TIM.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_USART.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_WWDG.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F10x_StdPeriph_Driver/src/misc.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/CMSIS/CM3/
	${STM_PERIPH_DRIVER_PATH}/Libraries/CMSIS/CM3/CoreSupport/core_cm3.c
	${STM_PERIPH_DRIVER_PATH}/Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x/system_stm32f10x.c
	${CMAKE_SOURCE_DIR}/config/vendor/ST/firmware/libSTMFirmware.c)

if(STM_USE_PERIPH_DRIVER)
  add_definitions(-DUSE_STDPERIPH_DRIVER)
	#set(VENDOR_C_FLAGS "${VENDOR_C_FLAGS} \"-DUSE_STDPERIPH_DRIVER\"")
	#set(VENDOR_CXX_FLAGS "${VENDOR_CXX_FLAGS} \"-DUSE_STDPERIPH_DRIVER\"")

	include_directories(
		"${STM_PERIPH_DRIVER_PATH}/Libraries/STM32F10x_StdPeriph_Driver/inc"
		"${STM_PERIPH_DRIVER_PATH}/Libraries/CMSIS/CM3/CoreSupport"
		"${STM_PERIPH_DRIVER_PATH}/Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x"
		"${CMAKE_SOURCE_DIR}/config/vendor/ST/firmware/include")
	
	add_library(STM32vlFirmware STATIC ${STM_PERIPH_DRIVER_FILES})
	
	set(VENDOR_FIRMWARE_TARGET STM32vlFirmware)
endif()

