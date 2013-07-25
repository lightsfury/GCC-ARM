if(NOT GCC_ARM_CHECK_BUILD_READY)

include(GCCARMDebugOutput)

if(NOT DEFINED CPU_TYPE)
	message(SEND_ERROR "The CPU type is not set. Please set the proper configuration targets.")
endif()

if(NOT DEFINED CODE_TYPE)
	message(SEND_ERROR "The instruction set is not set. Please set the proper configuration targets.")
endif()

if(NOT DEFINED VENDOR_LINK_SCRIPT)
	message(SEND_ERROR "The linker script is not set. Please set the proper configuration targets.")
endif()

if(NOT DEFINED VENDOR_BOOT_SCRIPT)
	DebugOutput("CheckBuildReady: Boot script not specified. Using default.")
	set(BOOT_SCRIPT "config/common/boot.c")
else()
	DebugOutput("CheckBuildReady: Using specified device boot script '${VENDOR_BOOT_SCRIPT}'.")
	set(BOOT_SCRIPT ${VENDOR_BOOT_SCRIPT})
endif()

if(NOT DEFINED VENDOR_ISR_VECTOR)
	message(SEND_ERROR "The ISR table definition is not set. Please set the proper configuration targets.")
endif()

if(NOT EXISTS "${CMAKE_SOURCE_DIR}/${VENDOR_LINK_SCRIPT}")
	message(SEND_ERROR "Cannot find the linker script. The path should be relative to CMAKE_SOURCE_DIR.\nCurrent path: ${VENDOR_LINK_SCRIPT}.")
else()
	set(VENDOR_LINK_SCRIPT "${CMAKE_SOURCE_DIR}/${VENDOR_LINK_SCRIPT}")
endif()

if(NOT EXISTS BOOT_SCRIPT)
	if(NOT EXISTS "${CMAKE_SOURCE_DIR}/${BOOT_SCRIPT}")
		message(SEND_ERROR "Cannot find the boot script. The path should be absolute or relative to CMAKE_SOURCE_DIR.\nCurrent path: ${BOOT_SCRIPT}.")
	else()
		set(BOOT_SCRIPT "${CMAKE_SOURCE_DIR}/${BOOT_SCRIPT}")
	endif()
endif()

if(NOT EXISTS VENDOR_ISR_VECTOR)
	if(NOT EXISTS "${CMAKE_SOURCE_DIR}/${VENDOR_ISR_VECTOR}")
		message(SEND_ERROR "Cannot find the ISR vector definition. The path should be absolute or relative to CMAKE_SOURCE_DIR.\nCurrent path: ${CMAKE_SOURCE_DIR}/${VENDOR_ISR_VECTOR}.")
	else()
		set(VENDOR_ISR_VECTOR "${CMAKE_SOURCE_DIR}/${VENDOR_ISR_VECTOR}")
	endif()
endif()

set(CMAKE_C_FLAGS "-Wall \"-m${CODE_TYPE}\" \"-mcpu=${CPU_TYPE}\" -g -gdwarf-2 ${VENDOR_C_FLAGS} ${GCC_ARM_OPTIMIZATION_FLAGS} ${GCC_ARM_ASSERT_FLAGS}")
set(CMAKE_CXX_FLAGS "-Wall \"-m${CODE_TYPE}\" \"-mcpu=${CPU_TYPE}\" -g -gdwarf-2 ${VENDOR_CXX_FLAGS} ${GCC_ARM_OPTIMIZATION_FLAGS} ${GCC_ARM_ASSERT_FLAGS}")
set(CMAKE_C_LINK_FLAGS "\"-m${CODE_TYPE}\" \"-mcpu=${CPU_TYPE}\" -L \"${CMAKE_SOURCE_DIR}/config\" -T \"${VENDOR_LINK_SCRIPT}\"")
set(CMAKE_CXX_LINK_FLAGS "\"-m${CODE_TYPE}\" \"-mcpu=${CPU_TYPE}\" -L \"${CMAKE_SOURCE_DIR}/config\" -T \"${VENDOR_LINK_SCRIPT}\"")

if(NOT LIBC_AUTO_LINK)
	set(CMAKE_C_LINK_FLAGS "${CMAKE_C_LINK_FLAGS} -nodefaultlibs")
	set(CMAKE_CXX_LINK_FLAGS "${CMAKE_CXX_LINK_FLAGS} -nodefaultlibs")
endif()

set(GCC_ARM_STARTUP_FILES ${BOOT_SCRIPT} ${VENDOR_ISR_VECTOR})

if(OPENOCD_SERVER_PATH)
	DebugOutput("CheckBuildReady: Adding brick retrieval target")
	add_custom_target(bricked-it
		"${OPENOCD_SERVER_PATH}" "${OPENOCD_CONFIG_TARGETS}" -f "${CMAKE_SOURCE_DIR}/${VENDOR_OPENOCD_SCRIPT}" -c "i_bricked_it" VERBATIM)
endif()

set(GCC_ARM_CHECK_BUILD_READY 1)
endif()
