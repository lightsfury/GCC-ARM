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
	
	if(LIBC_SYSCALL_IMPL)
		DebugOutput("AddBinary: Linking against specified syscall implementor '${LIBC_SYSCALL_IMPL}'.")
		target_link_libraries(${_target} ${LIBC_SYSCALL_IMPL})
	endif()
	
	if(OPENOCD_SERVER_PATH)
		DebugOutput("AddBinary: Creating download target for '${_target}'.")
		add_custom_target(download_${_target}
			"${OPENOCD_SERVER_PATH}" "${OPENOCD_CONFIG_TARGETS}" "-f${CMAKE_SOURCE_DIR}/${VENDOR_OPENOCD_SCRIPT}" -c "gcc_arm_flash ${_target}.elf" -c "shutdown"
			DEPENDS ${_target} WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/bin VERBATIM)
	endif()
	
	add_custom_command(TARGET ${_target} POST_BUILD
		COMMAND "arm-none-eabi-objcopy" "--only-keep-debug" "${_target}" "${_target}.debug"
		COMMAND "arm-none-eabi-objcopy" "--strip-debug" "--add-gnu-debuglink=${_target}.debug" "${_target}" "${_target}.bin"
		WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/bin VERBATIM)
	
	# @todo Split debugging information
	# http://stackoverflow.com/questions/866721/how-to-generate-gcc-debug-symbol-outside-the-build-target
	# http://stackoverflow.com/questions/5278444/adding-a-custom-command-with-the-file-name-as-a-target
	
endfunction()

set(GCC_ARM_ADD_BINARY_INCLUDED 1)
endif()
