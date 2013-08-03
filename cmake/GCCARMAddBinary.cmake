if(NOT GCC_ARM_ADD_BINARY_INCLUDED)
	include(GCCARMDebugOutput)
	include(GCCARMBuildFileList)

	function(AddBinary _target)
		DebugOutput("AddBinary: Creating executable for '${_target}'.")
		set(_files)
		# Build a list of the files passed
		foreach(i RANGE 1 ${ARGC})
			if("${ARGV${i}}" STREQUAL "EXCLUDE_FROM_ALL")
				DebugOutput("AddBinary: Found EXCLUDE_FROM_ALL sentinel. Adding to front of list.")
				list(INSERT _files 0 "${ARGV${i}}")
			else()
				DebugOutput("AddBinary: Adding file to list '${ARGV${i}}'.")
				list(APPEND _files "${ARGV${i}}")
			endif()
		endforeach()
		
		DebugOutput("AddBinary: Creating executable '${_target}' with files '${_files}'.")
		add_executable(${_target} ${_files} ${GCC_ARM_STARTUP_FILES})
		
		if(VENDOR_FIRMWARE_TARGET)
			DebugOutput("AddBinary: Linking against vendor firmware '${VENDOR_FIRMWARE_TARGET}'.")
			target_link_libraries(${_target} ${VENDOR_FIRMWARE_TARGET})
		endif()
		
		if(GCC_ARM_LIBC_SYSCALL_IMPL)
			DebugOutput("AddBinary: Linking against specified syscall implementor(s) '${GCC_ARM_LIBC_SYSCALL_IMPL}'.")
			target_link_libraries(${_target} ${GCC_ARM_LIBC_SYSCALL_IMPL})
		endif()
		
		if(GCC_ARM_OPENOCD_SERVER_PATH)
			DebugOutput("AddBinary: Creating download target for '${_target}'.")
			add_custom_target(download_${_target}
				"${GCC_ARM_OPENOCD_SERVER_PATH}" "${OPENOCD_CONFIG_TARGETS}" -c "program ${_target} verify reset"
				DEPENDS ${_target} WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/bin VERBATIM)
		endif()
		
		DebugOutput("AddBinary: Creating Eclipse debugging config file.")
		configure_file(
			"${CMAKE_SOURCE_DIR}/eclipse/debug.launch.in"
			"${CMAKE_BINARY_DIR}/eclipse/Debug ${_target}.launch")
		
		configure_file(
			"${CMAKE_SOURCE_DIR}/eclipse/debug2.launch.in"
			"${CMAKE_BINARY_DIR}/eclipse/Debug2 ${_target}.launch")
		
		DebugOutput("AddBinary: Splitting debug info to a .debug file.")
		add_custom_command(TARGET ${_target} POST_BUILD
			COMMAND ${GCC_ARM_OBJCOPY_PATH} "--only-keep-debug" "${_target}.elf" "${_target}.debug"
			COMMAND ${GCC_ARM_OBJCOPY_PATH} "--strip-debug" "--add-gnu-debuglink=${_target}.debug" "${_target}.elf" "${_target}"
			WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/bin VERBATIM)
		
		# @todo Split debugging information
		# http://stackoverflow.com/questions/866721/how-to-generate-gcc-debug-symbol-outside-the-build-target
		# http://stackoverflow.com/questions/5278444/adding-a-custom-command-with-the-file-name-as-a-target
		
	endfunction()

	set(GCC_ARM_ADD_BINARY_INCLUDED 1)
endif()
