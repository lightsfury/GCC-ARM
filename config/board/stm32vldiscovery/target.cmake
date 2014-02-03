message(STATUS "Loading configuration for STM32vldiscovery board")

# Include the configuration for the processor class
include(${CMAKE_SOURCE_DIR}/config/vendor/ST/STM32F10x/cpu.cmake)
# Include the configuration for the peripheral library
include(${CMAKE_SOURCE_DIR}/config/vendor/ST/STM32F10x/firmware.cmake)

# Board level options/settings
option(STM_PERIPH_DISCOVERY_FILES "Include the STM32vl peripheral discovery files." ON)

# OpenOCD configuration details
# Connection script
set(OPENOCD_CONFIG_TARGETS "-fboard/stm32vldiscovery.cfg")
# Does the OpenOCD configuration support the GDB DSF Launcher?
set(GCC_ARM_GDB_SUPPORT_DSF_LAUNCHER 1)
# How should OpenOCD initialize the connection
set(GCC_ARM_GDB_INIT_DEBUG "monitor reset halt")

# ST CPU specific
# Tell the STM Firmware which density class to target
add_definitions(-DSTM32F10X_MD_VL)

# How much "main" memory does the chip have?
# This does not include core-coupled memory and/or reserved block for 
# high speed peripherals. 
set(GCC_ARM_CPU_RAM_DENSITY   "8k")
# How much on-chip flash memory can we access?
set(GCC_ARM_CPU_FLASH_DENSITY "128k")
# Where does the "main" memory start?
set(GCC_ARM_CPU_RAM_ORIGIN    "0x20000000")
# Where does the on-chip flash memory start?
set(GCC_ARM_CPU_FLASH_ORIGIN  "0x08000000")

# Configure the linker script with the above values
# Should this be a helper function?
configure_file(
	${CMAKE_SOURCE_DIR}/config/common/memory.ld.in
	${CMAKE_BINARY_DIR}/config/common/memory.ld)

# Setup a custom linker script
 set(VENDOR_LINK_SCRIPT ${CMAKE_BINARY_DIR}/config/common/memory.ld)

if(STM_USE_PERIPH_DRIVER AND STM_PERIPH_DISCOVERY_FILES)
  add_definitions(-DUSE_STM_VL_DISCOVERY_FILES)
	
	include_directories("${STM_PERIPH_DRIVER_PATH}/Utilities")
	
	add_library(STM32vldiscoveryFirmware "${STM_PERIPH_DRIVER_PATH}/Utilities/STM32vldiscovery")
	
	set(VENDOR_FIRMWARE_TARGET STM32vlFirmware STM32vldiscoveryFirmware)
endif()

add_example_projects_path(example/common/Minimal example/board/stm32vldiscovery/LED)

#if(GCC_ARM_EXAMPLE_PROJECTS)
#  add_subdirectory(example/common/Minimal)
#  add_subdirectory(example/board/stm32vldiscovery/LED)
#endif()