if(NOT GCC_ARM_CHECK_BUILD_READY)
	include(GCCARMDebugOutput)

	# Ensure the CPU type is set (ie, Cortex M0/3/4)
	if(NOT DEFINED CPU_TYPE)
		message(SEND_ERROR "The CPU type is not set. Please set the proper configuration targets.")
	endif()

	# Ensure the instruction coding is declared (ie, ARM or Thumb)
	if(NOT DEFINED CODE_TYPE)
		message(SEND_ERROR "The instruction set is not set. Please set the proper configuration targets.")
	endif()

	# Ensure a linker script is provided
	if(NOT DEFINED VENDOR_LINK_SCRIPT)
		message(SEND_ERROR "The linker script is not set. Please set the proper configuration targets.")
	endif()

	# Fallback to a default boot script is a custom one is not specified
	if(NOT DEFINED VENDOR_BOOT_SCRIPT)
		DebugOutput("CheckBuildReady: Boot script not specified. Using default.")
		set(BOOT_SCRIPT "config/common/boot.c")
	else()
		DebugOutput("CheckBuildReady: Using specified device boot script '${VENDOR_BOOT_SCRIPT}'.")
		set(BOOT_SCRIPT ${VENDOR_BOOT_SCRIPT})
	endif()

	# Ensure the ISR vector is declared
	if(NOT DEFINED VENDOR_ISR_VECTOR)
		message(SEND_ERROR "The ISR table definition is not set. Please set the proper configuration targets.")
	endif()

	# Ensure the linker script exists on Disk
	if(NOT EXISTS "${VENDOR_LINK_SCRIPT}")
		if(NOT EXISTS "${CMAKE_SOURCE_DIR}/${VENDOR_LINK_SCRIPT}")
			message(SEND_ERROR "Cannot find the linker script. The path should be relative to CMAKE_SOURCE_DIR.\nCurrent path: ${VENDOR_LINK_SCRIPT}.")
		else()
			set(VENDOR_LINK_SCRIPT "${CMAKE_SOURCE_DIR}/${VENDOR_LINK_SCRIPT}")
		endif()
	endif()

	# Ensure the boot script exists on Disk
	if(NOT EXISTS ${BOOT_SCRIPT})
		if(NOT EXISTS "${CMAKE_SOURCE_DIR}/${BOOT_SCRIPT}")
			message(SEND_ERROR "Cannot find the boot script. The path should be absolute or relative to CMAKE_SOURCE_DIR.\nCurrent path: ${BOOT_SCRIPT}.")
		else()
			set(BOOT_SCRIPT "${CMAKE_SOURCE_DIR}/${BOOT_SCRIPT}")
		endif()
	endif()

	# Ensure the ISR vector exists on Disk
	if(NOT EXISTS ${VENDOR_ISR_VECTOR})
		if(NOT EXISTS "${CMAKE_SOURCE_DIR}/${VENDOR_ISR_VECTOR}")
			message(SEND_ERROR "Cannot find the ISR vector definition. The path should be absolute or relative to CMAKE_SOURCE_DIR.\nCurrent path: ${CMAKE_SOURCE_DIR}/${VENDOR_ISR_VECTOR}.")
		else()
			set(VENDOR_ISR_VECTOR "${CMAKE_SOURCE_DIR}/${VENDOR_ISR_VECTOR}")
		endif()
	endif()

	# Setup compiler flags
	set(CMAKE_C_FLAGS "-Wall \"-m${CODE_TYPE}\" \"-mcpu=${CPU_TYPE}\" -g -gdwarf-2 ${VENDOR_C_FLAGS} ${GCC_ARM_OPTIMIZATION_FLAGS} ${GCC_ARM_ASSERT_FLAGS}")
	set(CMAKE_CXX_FLAGS "-Wall \"-m${CODE_TYPE}\" \"-mcpu=${CPU_TYPE}\" -g -gdwarf-2 ${VENDOR_CXX_FLAGS} ${GCC_ARM_OPTIMIZATION_FLAGS} ${GCC_ARM_ASSERT_FLAGS}")
	# Setup linker flags
	set(CMAKE_C_LINK_FLAGS "\"-m${CODE_TYPE}\" \"-mcpu=${CPU_TYPE}\" -L \"${CMAKE_SOURCE_DIR}/config\" -T \"${VENDOR_LINK_SCRIPT}\"")
	set(CMAKE_CXX_LINK_FLAGS "\"-m${CODE_TYPE}\" \"-mcpu=${CPU_TYPE}\" -L \"${CMAKE_SOURCE_DIR}/config\" -T \"${VENDOR_LINK_SCRIPT}\"")

	# Optionally, set the float ABI
	if(CPU_FLOAT_ABI)
		set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mfloat-abi=${CPU_FLOAT_ABI}")
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mfloat-abi=${CPU_FLOAT_ABI}")
	endif()
	
	# Optionally, set the the FPU variant
	if(CPU_FLOAT_TYPE)
		set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mfpu=${CPU_FLOAT_TYPE}")
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mfpu=${CPU_FLOAT_TYPE}")
	endif()
	
	# Optionally, disable automatic linking of the default libraries
	if(NOT GCC_ARM_AUTO_LINK_LIBC)
		set(CMAKE_C_LINK_FLAGS "${CMAKE_C_LINK_FLAGS} -nodefaultlibs")
		set(CMAKE_CXX_LINK_FLAGS "${CMAKE_CXX_LINK_FLAGS} -nodefaultlibs")
	endif()

	# Abstract away the boot script and ISR vector definition
	set(GCC_ARM_STARTUP_FILES ${BOOT_SCRIPT} ${VENDOR_ISR_VECTOR})

	# Optionally, create an OpenOCD de-brick command and create Eclipse OpenOCD launch config file
	if(GCC_ARM_OPENOCD_SERVER_PATH)
		DebugOutput("CheckBuildReady: Adding brick retrieval target")
		add_custom_target(bricked-it
			"${GCC_ARM_OPENOCD_SERVER_PATH}" "${OPENOCD_CONFIG_TARGETS}" -f "${CMAKE_SOURCE_DIR}/${VENDOR_OPENOCD_SCRIPT}" -c "i_bricked_it" VERBATIM)
		set(OPENOCD_ECLIPSE_PARAMS "${OPENOCD_CONFIG_TARGETS}")
		configure_file(
			${CMAKE_SOURCE_DIR}/eclipse/OpenOCD.launch.in
			${CMAKE_BINARY_DIR}/eclipse/OpenOCD.launch)
	endif()
	
	if(GCC_ARM_GDB_SUPPORT_DSF_LAUNCHER)
		set(GCC_ARM_ECLIPSE_DEBUG_LAUNCHER "dsfLaunchDelegate")
	else()
		set(GCC_ARM_ECLIPSE_DEBUG_LAUNCHER "cdiLaunchDelegate")
	endif()

	# Find the full path to common utilities
	find_program(GCC_ARM_GDB_PATH "arm-none-eabi-gdb")
	find_program(GCC_ARM_OBJCOPY_PATH "arm-none-eabi-objcopy")
	
	# Construct the default Eclipse project name
	if(NOT GCC_ARM_ECLIPSE_PROJECT_NAME)
		string(REGEX REPLACE "^.*[/\\]([^/\\]+)[/\\]?$" "\\1" GCC_ARM_ECLIPSE_PROJECT_PATH_SEGMENT ${CMAKE_BINARY_DIR})
		
		if(GCC_ARM_ECLIPSE_PROJECT_PATH_SEGMENT)
			message(STATUS "Last segment in CMAKE_BINARY_DIR - FOUND - ${GCC_ARM_ECLIPSE_PROJECT_PATH_SEGMENT}")
			set(GCC_ARM_ECLIPSE_PROJECT_NAME "GCC_ARM@${GCC_ARM_ECLIPSE_PROJECT_PATH_SEGMENT}")
		else()
			message(STATUS "Last segment in CMAKE_BINARY_DIR - NOT FOUND")
		endif()
	endif()

	set(GCC_ARM_CHECK_BUILD_READY 1)
endif()
