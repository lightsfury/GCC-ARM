if(NOT GCC_ARM_HELPER_METHODS_INCLUDED)
	message(STATUS "Including helper methods")

	function(DebugOutput)
		if(${GCC_ARM_CMAKE_DEBUG_OUTPUT})
			message(STATUS ${ARGN})
		endif()
	endfunction()
	
	function(JoinList output glue)
		DebugOutput("JoinList: Joining '${ARGN}' with '${glue}'.")
		foreach(i ${ARGN})
			DebugOutput("JoinList: Adding '${i}'.")
			set(_newList "${_newList}${glue}${i}")
		endforeach()
		
		DebugOutput("JoinList: Trimming excess glue '${_newList}'")
		string(REGEX REPLACE "^${glue}(.*)$" "\\1" _newList "${_newList}")
		
		set(${output} "${_newList}" PARENT_SCOPE)
	endfunction()
	
	function(ModifyList _list prefix suffix)
		DebugOutput("ModifyList: Modifying input items '${${_list}}'.")
		foreach(i IN LISTS ${_list})
			DebugOutput("ModifyList: Adding item '${i}'.")
			list(APPEND newList "${prefix}${i}${suffix}")
		endforeach()
		
		set(${_list} ${newList} PARENT_SCOPE)
	endfunction()
	
	# @todo Should this use an output variable and let the caller worry about
	# the side effects?
	function(VerifyList output inputValidList)
		DebugOutput("VerifyList: Sorting input valid list '${inputValidList}'.")
		list(SORT inputValidList)
		DebugOutput("VerifyList: Joining input valid list '${inputValidList}'.")
		JoinList(validList ", " "${inputValidList}")
		
		DebugOutput("VerifyList: Verifying input list '${ARGN}'.")
		foreach(i ${ARGN})
			if(NOT "${validList}" MATCHES "${i}")
				DebugOutput("VerifyList: Found invalid item '${i}'.")
				set(invalid 1)
				break()
			else()
				DebugOutput("VerifyList: Found valid item '${i}'.")
			endif()
		endforeach()
		
		if(NOT DEFINED invalid OR NOT invalid)
			DebugOutput("VerifyList: Found valid list")
			set(${output} 1 PARENT_SCOPE)
		else()
			DebugOutput("VerifyList: Found invalid list")
			set(${output} 0 PARENT_SCOPE)
		endif()
	endfunction()
	
	set(VALID_DEBUG_OPTIONS
		Assert
		SizeOpt)
	
	function(LoadDebugOptions)
		VerifyList(DEBUG_OPTIONS_ARE_VALID ${VALID_DEBUG_OPTIONS} ${GCC_ARM_DEBUG_OPTIONS})
		if(NOT DEBUG_OPTIONS_ARE_VALID)
			message(FATAL_ERROR "One or more requested debug options is not supported. Please verify the contents of GCC_ARM_DEBUG_OPTIONS: ${GCC_ARM_DEBUG_OPTIONS}.")
		endif()
		
		foreach(opt ${GCC_ARM_DEBUG_OPTIONS})
			include("DebugOptions/${opt}")
		endforeach()
	endfunction()
	
	# Use a macro so that all set() calls are "implicitly" PARENT_SCOPE'd
	macro(ConfigureBuildFlags)
		message(STATUS "Configuring build flags")
		
		# The CPU type is required
		if(NOT CPU_TYPE)
			message(FATAL_ERROR "The target CPU type is not set. Please set GCC_ARM_CONFIGURATION_TARGETS to a supported device configuration.")
		endif()
		DebugOutput("Targetting '${CPU_TYPE}' CPUs.")
		
		# The instruction set is required
		if(NOT CODE_TYPE)
			message(FATAL_ERROR "The target instruction set is not set. Please set GCC_ARM_CONFIGURATION_TARGETS to a supported device configuration.")
		endif()
		DebugOutput("Targetting '${CODE_TYPE}' instruction set.")
		
		# A linker script is required
		if(NOT VENDOR_LINK_SCRIPT)
			message(FATAL_ERROR "The target link script is not set. Please set GCC_ARM_CONFIGURATION_TARGETS to a supported device configuration.")
		endif()
		
		# A boot script is required
		if(NOT VENDOR_BOOT_SCRIPT)
			# Fallback to the default boot script
			message(STATUS "Using the default boot script")
			set(BOOT_SCRIPT "config/common/boot.c")
		else()
			message(STATUS "Using the vendor boot script - ${VENDOR_BOOT_SCRIPT}")
			set(BOOT_SCRIPT ${VENDOR_BOOT_SCRIPT})
		endif()
		
		# The ISR declaration is required
		if(NOT VENDOR_ISR_VECTOR)
			message(FATAL_ERROR "The ISR declaration is not set. Please set GCC_ARM_CONFIGURATION_TARGETS to a supported device configuration.")
		endif()
		
		# The linker script must exist 
		if(NOT EXISTS "${VENDOR_LINK_SCRIPT}")
			if(NOT EXISTS "${CMAKE_SOURCE_DIR}/${VENDOR_LINK_SCRIPT}")
				message(FATAL_ERROR "Cannot find the linker script. The path should be absolute or relative to CMAKE_SOURCE_DIR.\nCurrent patH: ${VENDOR_LINK_SCRIPT}")
			else()
				set(VENDOR_LINK_SCRIPT "${CMAKE_SOURCE_DIR}/${VENDOR_LINK_SCRIPT}")
			endif()
		endif()
		
		# The boot script must exist 
		if(NOT EXISTS "${BOOT_SCRIPT}")
			if(NOT EXISTS "${CMAKE_SOURCE_DIR}/${BOOT_SCRIPT}")
				message(FATAL_ERROR "Cannot find the boot script. The path should be absolute or relative to CMAKE_SOURCE_DIR.\nCurrent patH: ${BOOT_SCRIPT}")
			else()
				set(BOOT_SCRIPT "${CMAKE_SOURCE_DIR}/${BOOT_SCRIPT}")
			endif()
		endif()
		
		# The ISR declaration must exist 
		if(NOT EXISTS "${VENDOR_ISR_VECTOR}")
			if(NOT EXISTS "${CMAKE_SOURCE_DIR}/${VENDOR_ISR_VECTOR}")
				message(FATAL_ERROR "Cannot find the ISR declaration. The path should be absolute or relative to CMAKE_SOURCE_DIR.\nCurrent patH: ${VENDOR_ISR_VECTOR}")
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

		# Optionally, setup the float ABI
		if(CPU_FLOAT_ABI)
			set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mfloat-abi=${CPU_FLOAT_ABI}")
			set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mfloat-abi=${CPU_FLOAT_ABI}")
		endif()
		
		# Optionally, setup the FPU variant
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
			message(STATUS "Adding a brick retrieval target")
			add_custom_target(bricked-it
				"${GCC_ARM_OPENOCD_SERVER_PATH}" "${OPENOCD_CONFIG_TARGETS}" -f "${CMAKE_SOURCE_DIR}/${VENDOR_OPENOCD_SCRIPT}" -c "i_bricked_it" VERBATIM)
			set(OPENOCD_ECLIPSE_PARAMS "${OPENOCD_CONFIG_TARGETS}")
			# The Eclipse debug launchers automatically launch OpenOCD
			# Are these still necessary?
			#configure_file(
			#	${CMAKE_SOURCE_DIR}/eclipse/OpenOCD.launch.in
			#	${CMAKE_BINARY_DIR}/eclipse/OpenOCD.launch)
		endif()
		
		# Select the proper Eclipse GDB launcher
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
	endmacro()
	
	macro(LoadConfigurationTargets)
		foreach(target ${GCC_ARM_CONFIGURATION_TARGETS})
			include("${CMAKE_SOURCE_DIR}/config/${target}/target.cmake")
		endforeach()
	endmacro()
	
	function(AddBinary targetName)
		DebugOutput("AddBinary: Creating executable '${targetName}' from files '${ARGN}'.")
		add_executable(${targetName} ${ARGN} ${GCC_ARM_STARTUP_FILES})
		
		if(VENDOR_FIRMWARE_TARGET)
			DebugOutput("AddBinary: Linking against vendor firmware '${VENDOR_FIRMWARE_TARGET}'.")
			target_link_libraries(${targetName} ${VENDOR_FIRMWARE_TARGET})
		endif()
		
		if(GCC_ARM_LIBC_SYSCALL_IMPL)
			DebugOutput("AddBinary: Linking against specified syscall implementor(s) '${GCC_ARM_LIBC_SYSCALL_IMPL}'.")
			target_link_libraries(${targetName} ${GCC_ARM_LIBC_SYSCALL_IMPL})
		endif()
		
		if(GCC_ARM_AUTO_LINK_LIBC)
			DebugOutput("AddBinary: Adding work-around for syscall circular references.")
			target_link_libraries(${targetName} gcc c)
		endif()
		
		if(GCC_ARM_OPENOCD_SERVER_PATH)
			DebugOutput("AddBinary: Creating download target for '${targetName}'.")
			add_custom_target(download_${targetName}
				"${GCC_ARM_OPENOCD_SERVER_PATH}" "${OPENOCD_CONFIG_TARGETS}" -c "program ${targetName} verify reset"
				DEPENDS ${targetName} WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/bin VERBATIM)
		endif()
		
		if(GCC_ARM_ECLIPSE_PROJECT_NAME AND GCC_ARM_OPENOCD_SERVER_PATH AND GCC_ARM_GDB_PATH)
			DebugOutput("AddBinary: Creating Eclipse debugging config file.")
			configure_file(
				"${CMAKE_SOURCE_DIR}/eclipse/debug.launch.in"
				"${CMAKE_BINARY_DIR}/eclipse/Debug ${targetName}.launch")
		endif()
		
		DebugOutput("AddBinary: Splitting debug info to a .debug file.")
		add_custom_command(TARGET ${targetName} POST_BUILD
			COMMAND ${GCC_ARM_OBJCOPY_PATH} "--only-keep-debug" "${targetName}.elf" "${targetName}.debug"
			COMMAND ${GCC_ARM_OBJCOPY_PATH} "--strip-debug" "--add-gnu-debuglink=${targetName}.debug" "${targetName}.elf" "${targetName}"
			WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/bin VERBATIM)
	endfunction()
	
	set(GCC_ARM_HELPER_METHODS_INCLUDED 1)
endif()
