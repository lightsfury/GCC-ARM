message(STATUS "Loading configuration for STM32F3 discovery boards")

include(${CMAKE_SOURCE_DIR}/config/vendor/ST/STM32F429/cpu.cmake)
include(${CMAKE_SOURCE_DIR}/config/vendor/ST/STM32F429/firmware.cmake)

option(STM_PERIPH_DISCOVERY_FILES "Include the STM32vl peripheral discovery files." ON)

# Tell OpenOCD where to find the board script
set(OPENOCD_CONFIG_TARGETS "-fboard/stm32f4discovery.cfg")
set(GCC_ARM_GDB_SUPPORT_DSF_LAUNCHER 1)
set(GCC_ARM_GDB_INIT_DEBUG "monitor reset halt")

# Tell the STM Firmware which density class to target
add_definitions(-DSTM32F429_439xx)

# The board is marketed as having 260kB of RAM
# Its not quite a lie, but 4kB is reserved for USB storage
# and 64kB is core-coupled (ie instruction RAM).
set(GCC_ARM_CPU_RAM_DENSITY   "192k")
set(GCC_ARM_CPU_FLASH_DENSITY "1M")
set(GCC_ARM_CPU_RAM_ORIGIN    "0x20000000")
set(GCC_ARM_CPU_FLASH_ORIGIN  "0x08000000")

configure_file(
	${CMAKE_SOURCE_DIR}/config/common/memory.ld.in
	${CMAKE_BINARY_DIR}/config/common/memory.ld)

set(VENDOR_LINK_SCRIPT ${CMAKE_BINARY_DIR}/config/common/memory.ld)

if(STM_USE_PERIPH_DRIVER AND STM_PERIPH_DISCOVERY_FILES)
  add_definitions(-DUSE_STM32F429I_DISCO)
	
	include_directories("${STM_PERIPH_DRIVER_PATH}/Utilities/STM32F429I-Discovery")
	
	add_library(STM32F429discoveryFirmware
		${STM_PERIPH_DRIVER_PATH}/Utilities/STM32F429I-Discovery/stm32f429i_discovery
		${STM_PERIPH_DRIVER_PATH}/Utilities/STM32F429I-Discovery/stm32f429i_discovery_i2c_ee
		${STM_PERIPH_DRIVER_PATH}/Utilities/STM32F429I-Discovery/stm32f429i_discovery_ioe
		${STM_PERIPH_DRIVER_PATH}/Utilities/STM32F429I-Discovery/stm32f429i_discovery_l3gd20
		${STM_PERIPH_DRIVER_PATH}/Utilities/STM32F429I-Discovery/stm32f429i_discovery_lcd
		${STM_PERIPH_DRIVER_PATH}/Utilities/STM32F429I-Discovery/stm32f429i_discovery_sdram)
	
	set(VENDOR_FIRMWARE_TARGET ${VENDOR_FIRMWARE_TARGET} STM32F429discoveryFirmware)
endif()

add_example_projects_path(example/common/Minimal example/board/stm32f429discovery/LED example/board/stm32f429discovery/Compass)
