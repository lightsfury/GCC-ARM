
if(NOT GENERIC_GNU_INCLUDED)
	message(STATUS "Updating build commands")

	# Set binary extension
	set(CMAKE_EXECUTABLE_SUFFIX ".elf")

	# Setup the system for assembly files
	set(CMAKE_ASM_SOURCE_FILE_EXTENSIONS asm)
	set(CMAKE_ASM_OUTPUT_EXTENSION ".o")
	set(CMAKE_ASM_COMPILE_OBJECT "<CMAKE_ASM_COMPILER> <FLAGS> -c -x assembler-with-cpp -o <OBJECT> <SOURCE>")
	
	# Setup the system for C files
	set(CMAKE_C_OUTPUT_EXTENSION ".o")
	set(CMAKE_C_LINK_EXECUTABLE "<CMAKE_C_COMPILER> <CMAKE_C_LINK_FLAGS> -nostartfiles <OBJECTS> -o <TARGET> -Wl,--start-group <LINK_LIBRARIES> -Wl,--end-group")
	# Disable shared/module libraries
	set(CMAKE_C_CREATE_SHARED_LIBRARY)
	set(CMAKE_C_CREATE_MODULE_LIBRARY)
	
	# Setup the system for CXX files
	set(CMAKE_CXX_OUTPUT_EXTENSION ".o")
	set(CMAKE_CXX_LINK_EXECUTABLE "<CMAKE_CXX_COMPILER> <CMAKE_CXX_LINK_FLAGS> -nostartfiles <OBJECTS> -o <TARGET> -Wl,--start-group <LINK_LIBRARIES> -Wl,--end-group")
	# Disable shared/module libraries
	set(CMAKE_CXX_CREATE_SHARED_LIBRARY)
	set(CMAKE_CXX_CREATE_MODULE_LIBRARY)
	
	set(GENERIC_GNU_INCLUDED 1)
endif()
