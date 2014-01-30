message(STATUS "Loading configuration for STM32F3 discovery boards")

include(${CMAKE_SOURCE_DIR}/config/vendor/ST/STM32F30x/cpu.cmake)
include(${CMAKE_SOURCE_DIR}/config/vendor/ST/STM32F30x/firmware.cmake)

option(STM_PERIPH_DISCOVERY_FILES "Include the STM32vl peripheral discovery files." ON)

# Tell OpenOCD where to find the board script
set(OPENOCD_CONFIG_TARGETS "-fboard/stm32f3discovery.cfg")
set(GCC_ARM_GDB_SUPPORT_DSF_LAUNCHER 1)
set(GCC_ARM_GDB_INIT_DEBUG "monitor reset halt")

# Tell the STM Firmware which density class to target
add_definitions(-DSTM32F30X)
#set(VENDOR_C_FLAGS "${VENDOR_C_FLAGS} -DSTM32F30X")
#set(VENDOR_CXX_FLAGS "${VENDOR_CXX_FLAGS} -DSTM32F30X")

set(GCC_ARM_CPU_RAM_DENSITY   "40k")
set(GCC_ARM_CPU_FLASH_DENSITY "256k")
set(GCC_ARM_CPU_RAM_ORIGIN    "0x20000000")
set(GCC_ARM_CPU_FLASH_ORIGIN  "0x08000000")

configure_file(
	${CMAKE_SOURCE_DIR}/config/common/memory.ld.in
	${CMAKE_BINARY_DIR}/config/common/memory.ld)

set(VENDOR_LINK_SCRIPT ${CMAKE_BINARY_DIR}/config/common/memory.ld)

if(STM_USE_PERIPH_DRIVER AND STM_PERIPH_DISCOVERY_FILES)
  add_definitions(-DUSE_STM_F3_DISCOVERY_FILES)
	#set(VENDOR_C_FLAGS "${VENDOR_C_FLAGS} \"-DUSE_STM_F3_DISCOVERY_FILES\"")
	#set(VENDOR_CXX_FLAGS "${VENDOR_CXX_FLAGS} \"-DUSE_STM_F3_DISCOVERY_FILES\"")
	
	include_directories("${STM_PERIPH_DRIVER_PATH}/Utilities/STM32F3_Discovery")
	
	add_library(STM32F3discoveryFirmware
		${STM_PERIPH_DRIVER_PATH}/Utilities/STM32F3_Discovery/stm32f3_discovery
		${STM_PERIPH_DRIVER_PATH}/Utilities/STM32F3_Discovery/stm32f3_discovery_l3gd20
		${STM_PERIPH_DRIVER_PATH}/Utilities/STM32F3_Discovery/stm32f3_discovery_lsm303dlhc	)
	
	set(VENDOR_FIRMWARE_TARGET ${VENDOR_FIRMWARE_TARGET} STM32F3discoveryFirmware)
endif()

if(GCC_ARM_EXAMPLE_PROJECTS)
  add_subdirectory(example/common/Minimal)
  add_subdirectory(example/board/stm32f3discovery/LED)
endif()
