if(NOT GCC_ARM_CHECK_BUILD_READY)

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
	message(SEND_ERROR "The boot script is not set. Please set the proper configuration targets.")
endif()

if(NOT DEFINED VENDOR_ISR_VECTOR)
	message(SEND_ERROR "The ISR table definition is not set. Please set the proper configuration targets.")
endif()

if(NOT EXISTS VENDOR_LINK_SCRIPT)
	if(NOT EXISTS "${CMAKE_SOURCE_DIR}/${VENDOR_LINK_SCRIPT}")
		message(SEND_ERROR "Cannot find the linker script. The path should be absolute or relative to CMAKE_SOURCE_DIR.\nCurrent path: ${CMAKE_SOURCE_DIR}/${VENDOR_LINK_SCRIPT}.")
	else()
		set(VENDOR_LINK_SCRIPT "${CMAKE_SOURCE_DIR}/${VENDOR_LINK_SCRIPT}")
	endif()
endif()

if(NOT EXISTS VENDOR_BOOT_SCRIPT)
	if(NOT EXISTS "${CMAKE_SOURCE_DIR}/${VENDOR_BOOT_SCRIPT}")
		message(SEND_ERROR "Cannot find the boot script. The path should be absolute or relative to CMAKE_SOURCE_DIR.\nCurrent path: ${CMAKE_SOURCE_DIR}/${VENDOR_BOOT_SCRIPT}.")
	else()
		set(VENDOR_BOOT_SCRIPT "${CMAKE_SOURCE_DIR}/${VENDOR_BOOT_SCRIPT}")
	endif()
endif()

if(NOT EXISTS VENDOR_ISR_VECTOR)
	if(NOT EXISTS "${CMAKE_SOURCE_DIR}/${VENDOR_ISR_VECTOR}")
		message(SEND_ERROR "Cannot find the ISR vector definition. The path should be absolute or relative to CMAKE_SOURCE_DIR.\nCurrent path: ${CMAKE_SOURCE_DIR}/${VENDOR_ISR_VECTOR}.")
	else()
		set(VENDOR_ISR_VECTOR "${CMAKE_SOURCE_DIR}/${VENDOR_ISR_VECTOR}")
	endif()
endif()

set(CMAKE_C_FLAGS "\"-m${CODE_TYPE}\" \"-mcpu=${CPU_TYPE}\" ${VENDOR_C_FLAGS} ${GCC_ARM_OPTIMIZATION_FLAGS} ${GCC_ARM_ASSERT_FLAGS}")
set(CMAKE_CXX_FLAGS  "\"-m${CODE_TYPE}\" \"-mcpu=${CPU_TYPE}\" ${VENDOR_CXX_FLAGS} ${GCC_ARM_OPTIMIZATION_FLAGS} ${GCC_ARM_ASSERT_FLAGS}")
set(CMAKE_C_LINK_FLAGS "\"-m${CODE_TYPE}\" \"-mcpu=${CPU_TYPE}\" -T \"${VENDOR_LINK_SCRIPT}\" -nostartfiles")
set(CMAKE_CXX_LINK_FLAGS "\"-m${CODE_TYPE}\" \"-mcpu=${CPU_TYPE}\" -T \"${VENDOR_LINK_SCRIPT}\" -nostartfiles")

if(NOT LIBC_AUTO_LINK)
	set(CMAKE_C_LINK_FLAGS "${CMAKE_C_LINK_FLAGS} -nodefaultlibs")
	set(CMAKE_CXX_LINK_FLAGS "${CMAKE_CXX_LINK_FLAGS} -nodefaultlibs")
endif()

set(GCC_ARM_STARTUP_FILES ${VENDOR_BOOT_SCRIPT} ${VENDOR_ISR_VECTOR})

set(GCC_ARM_CHECK_BUILD_READY 1)
endif()
