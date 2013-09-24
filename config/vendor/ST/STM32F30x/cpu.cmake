message(STATUS "Loading configuration for STM32F30x")

set(CPU_TYPE "cortex-m4")
set(CODE_TYPE "thumb")
set(CPU_FLOAT_ABI "softfp")
set(CPU_FLOAT_TYPE "fpv4-sp-d16")

set(VENDOR_ISR_VECTOR "${CMAKE_SOURCE_DIR}/config/vendor/ST/STM32F30x/isr_vector.c")
set(VENDOR_OPENOCD_SCRIPT "${CMAKE_SOURCE_DIR}/config/vendor/ST/STM32F30x/debrick.cfg")
