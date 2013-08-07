message(STATUS "Loading configuration for STM32vldiscovery board")

include(GCCARMParseDebugLevel)

include(${CMAKE_SOURCE_DIR}/config/vendor/ST/STM32F10x/cpu.cmake)
include(${CMAKE_SOURCE_DIR}/config/vendor/ST/STM32F10x/firmware.cmake)

option(STM_PERIPH_DISCOVERY_FILES "Include the STM32vl peripheral discovery files." ON)

# Tell OpenOCD where to find the board script
set(OPENOCD_CONFIG_TARGETS "-fboard/stm32vldiscovery.cfg")
set(GCC_ARM_GDB_SUPPORT_DSF_LAUNCHER 1)
set(GCC_ARM_GDB_INIT_DEBUG "monitor reset halt")

# Tell the STM Firmware which density class to target
set(VENDOR_C_FLAGS "${VENDOR_C_FLAGS} -DSTM32F10X_MD_VL")
set(VENDOR_CXX_FLAGS "${VENDOR_CXX_FLAGS} -DSTM32F10X_MD_VL")

set(GCC_ARM_CPU_RAM_DENSITY   "8k")
set(GCC_ARM_CPU_FLASH_DENSITY "128k")
set(GCC_ARM_CPU_RAM_ORIGIN    "0x20000000")
set(GCC_ARM_CPU_FLASH_ORIGIN  "0x08000000")

configure_file(
	${CMAKE_SOURCE_DIR}/config/common/memory.ld.in
	${CMAKE_BINARY_DIR}/config/common/memory.ld)

set(VENDOR_LINK_SCRIPT ${CMAKE_BINARY_DIR}/config/common/memory.ld)

if(STM_USE_PERIPH_DRIVER AND STM_PERIPH_DISCOVERY_FILES)
	set(VENDOR_C_FLAGS "${VENDOR_C_FLAGS} \"-DUSE_STM_VL_DISCOVERY_FILES\"")
	set(VENDOR_CXX_FLAGS "${VENDOR_CXX_FLAGS} \"-DUSE_STM_VL_DISCOVERY_FILES\"")
	
	include_directories("${STM_PERIPH_DRIVER_PATH}/Utilities")
	
	add_library(STM32vldiscoveryFirmware "${STM_PERIPH_DRIVER_PATH}/Utilities/STM32vldiscovery")
	
	set(VENDOR_FIRMWARE_TARGET STM32vlFirmware STM32vldiscoveryFirmware)
endif()
