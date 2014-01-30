message(STATUS "Loading configuration for STM32F429")

set(CPU_TYPE "cortex-m4")
set(CODE_TYPE "thumb")
set(CPU_FLOAT_ABI "softfp")
set(CPU_FLOAT_TYPE "fpv4-sp-d16")

set(VENDOR_ISR_VECTOR "${CMAKE_SOURCE_DIR}/config/vendor/ST/STM32F429/isr_vector.c")
set(VENDOR_OPENOCD_SCRIPT "${CMAKE_SOURCE_DIR}/config/vendor/ST/STM32F429/debrick.cfg")
