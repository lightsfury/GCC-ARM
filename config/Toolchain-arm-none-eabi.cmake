# This is the CMake cross-compiler toolchain file for arm-none-eabi
# Since we need special control of the toolchain, we must force the compilers
message(STATUS "Configuring toolchain")
include(CMakeForceCompiler)

# This specifies the OS/platform type. That is: Linux, Cygwin, Win32, etc
set(CMAKE_SYSTEM_NAME Generic)

CMAKE_FORCE_C_COMPILER(arm-none-eabi-gcc GNU)
CMAKE_FORCE_CXX_COMPILER(arm-none-eabi-g++ GNU)

set(CMAKE_EXECUTABLE_SUFFIX ".elf")