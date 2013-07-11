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
		target_link_libraries(${_target} ${VENDOR_FIRMWARE_TARGET})
	endif()
	
	if(LIBC_SYSCALL_IMPL)
		target_link_libraries(${_target} ${LIBC_SYSCALL_IMPL})
	endif()
	
	if(OPENOCD_SERVER_PATH)
		add_custom_target(download_${_target} "${OPENOCD_SERVER_PATH}" "${OPENOCD_CONFIG_TARGETS}" "-f${CMAKE_SOURCE_DIR}/${VENDOR_OPENOCD_SCRIPT}" -c "gcc_arm_flash ${_target}.elf" -c "shutdown" DEPENDS ${_target} WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/bin VERBATIM)
	endif()
	
	# @todo Split debugging information
	
endfunction()

set(GCC_ARM_ADD_BINARY_INCLUDED 1)
endif()
