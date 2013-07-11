# See docs/Build.html for information on building the template project

project(GCC_ARM)
cmake_minimum_required(VERSION 2.8)

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
    message(FATAL_ERROR
"In-source builds are not allowed. Please specify a directory outside
the GCC-ARM directory. This process created the file 'CMakeCache.txt' and
the directory 'CMakeFiles'; please delete them.")
endif()

# Update module path with custom modules
set(CMAKE_MODULE_PATH
    ${CMAKE_MODULE_PATH}
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake"
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules")

# Setup proper output directories
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

# Configurable settings
set(TOOLCHAIN_PATH "" CACHE PATH "Place to the root directory of the toolchain")
set(CONFIGURATION_TARGETS "" CACHE STRING "List of identifiers used to locate the board/CPU configuration(s). Please seperate IDs with a semicolon.")
option(LIBC_AUTO_LINK "Automatically link against the libc implementation." ON)
set(LIBC_SYSCALL_IMPL "rdimon" CACHE STRING "Library to use for syscall emulation/imlpementation.")
set(OPENOCD_SERVER_PATH "" CACHE FILEPATH "Path to the OpenOCD server executable.")
set(DEBUG_LEVEL "Assert;SizeOpt" CACHE STRING "Specifies the presence of assertions and optimizations. Please seperate IDs with a semicolon.")
option(GCC_ARM_RUN_CMAKE_TESTS "Run the test suite for the CMake helper functions." OFF)
option(GCC_ARM_CMAKE_DEBUG_MESSAGES "Display debug messages from CMake helper functions." OFF)

if(GCC_ARM_RUN_CMAKE_TESTS)
	message(STATUS "Running CMake tests")
	include(GCCARM_testsuite)
else()
	# Start the build magic
	foreach(target ${CONFIGURATION_TARGETS})
		include("${CMAKE_SOURCE_DIR}/config/${target}/target.cmake")
	endforeach()

	include(GCCARMCheckBuildReady)

	include_directories("${CMAKE_SOURCE_DIR}/include")
	link_directories("${CMAKE_BINARY_DIR}")

	add_subdirectory(src)
endif()
