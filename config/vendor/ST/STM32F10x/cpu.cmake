message(STATUS "Configuring build to target STM32F10x")

set(CPU_TYPE "cortex-m3")
set(CODE_TYPE "thumb")
set(CPU_FLOAT_ABI "soft")

set(VENDOR_ISR_VECTOR "config/vendor/ST/STM32F10x/isr_vector.c")
set(VENDOR_OPENOCD_SCRIPT "config/board/ST/STM32F10x/debrick.cfg")
