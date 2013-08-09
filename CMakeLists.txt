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

# Include platform configuration and helper methods
include(Platform/Generic-GNU)
include(GCCARM/HelperMethods)

# Setup proper output directories
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

# Configurable settings
set(GCC_ARM_CONFIGURATION_TARGETS "" CACHE STRING "List of identifiers used to locate the device configuartion(s). Please seperate IDs with a semicolon (;).")
set(GCC_ARM_LIBC_SYSCALL_IMPL "rdimon" CACHE STRING "Library or libraries used to locate syscall emulation/implementation. Please seperate library names with a semicolon (;).")
set(GCC_ARM_OPENOCD_SERVER_PATH "" CACHE FILEPATH "Absolute path to the OpenOCD server executable.")
set(GCC_ARM_DEBUG_OPTIONS "Assert;SizeOpt" CACHE STRING "Specify the debug options to use. Debugging information is always generated and place in a seperate .debug file.")
#set(GCC_ARM_ECLIPSE_PROJECT_NAME "GCC ARM" CACHE STRING "Project name used to create Eclipse debugging configuration files.")

option(GCC_ARM_AUTO_LINK_LIBC "Automatically link against the libc implementation." ON)
option(GCC_ARM_RUN_CMAKE_TESTS "Run the test suite for the CMake helper functions." OFF)
option(GCC_ARM_CMAKE_DEBUG_OUTPUT "Display debug messages from CMake helper functions." OFF)

if(GCC_ARM_RUN_CMAKE_TESTS)
	message(STATUS "Running CMake tests")
	include(GCCARM/TestSuite)
else()
	# Start the build magic
	foreach(target ${GCC_ARM_CONFIGURATION_TARGETS})
		include("${CMAKE_SOURCE_DIR}/config/${target}/target.cmake")
	endforeach()

	ConfigureBuildFlags()

	include_directories("${CMAKE_SOURCE_DIR}/include")
	link_directories("${CMAKE_BINARY_DIR}")

	add_subdirectory(src)
endif()
