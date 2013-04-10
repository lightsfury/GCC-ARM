# @section User variables
USER_PROJECT_NAME		= gcc-arm-stm32f10x
USER_DEVICE_CLASS		= stm32f10x-md-vl

# @section User defines
USER_C_DEFINES			=
USER_ASM_DEFINES		=
USER_CXX_DEFINES		=

# @section User include & library path
# @note All paths should end with a directory seperator (/)
USER_INCLUDE_PATH		= ./inc/
USER_LIBRARY_PATH		=
USER_LIBRARIES			=

# @section Device firmware package info
STM_PERIPH_DRIVER_PATH	= ../Discovery/
STM_PERIPH_DRIVER_FILES	= RCC I2C PWR GPIO EXTI
STM_DISCOVERY_FILES		= 1
ST_LINK_CLI_PATH		= "C:\Program Files (x86)\STMicroelectronics\STM32 ST-LINK Utility\ST-LINK Utility\st-link_cli.exe"

# @section User source path
USER_C_FILES			= ./src/main.c ./src/stm32f10x_it.c
USER_CXX_FILES			=
USER_ASM_FILES			=

DEBUG_BUILD				= 1
# End of user variables

# Include platform dependent variables
-include ./platform.d/$(USER_DEVICE_CLASS).Makefile

# @section Build variables
TARGET			= arm-none-eabi-
C_COMPILER		= $(TARGET)gcc
CXX_COMPILER	= $(TARGET)g++
ASM_COMPILER	= $(TARGET)g++ -x assembler-with-cpp
MAKE_HEX		= $(TARGET)objcopy -O ihex
MAKE_BIN		= $(TARGET)objcopy -O binary -S

SOURCE_FILES	= $(USER_CXX_FILES) $(USER_C_FILES) $(USER_ASM_FILES) $(_TARGET_CORE_FILES)
C_FILES			= $(filter %.c, $(SOURCE_FILES))
CXX_FILES		= $(filter %.cpp, $(SOURCE_FILES))
ASM_FILES		= $(filter %.s, $(SOURCE_FILES))
OBJECT_FILES	= $(C_FILES:.c=.c-o) $(CXX_FILES:.cpp=.cpp-o) $(ASM_FILES:.s=.s-o)
LIBS			= $(USER_LIBRARIES)

INCLUDE_PATH	= $(patsubst %, "-I%", $(USER_INCLUDE_PATH) $(_TARGET_INCLUDE_PATH))
LIBRARY_PATH	= $(patsubst %, "-L%", $(USER_LIBRARY_PATH) $(_TARGET_LIBRARY_PATH))

ASM_FLAGS		= $(_TARGET_COMPILER_FLAGS) $(USER_ASM_DEFINES)
C_FLAGS			= $(_TARGET_COMPILER_FLAGS)	$(USER_C_DEFINES) -Wall
CXX_FLAGS		= $(_TARGET_COMPILER_FLAGS) $(USER_CXX_DEFINES) -Wall

# @section Build target
all: $(OBJECT_FILES) $(USER_PROJECT_NAME).elf $(USER_PROJECT_NAME).hex
	$(TARGET)size $(USER_PROJECT_NAME).elf

%c-o: %c
	$(C_COMPILER) -c $(C_FLAGS) $(INCLUDE_PATH) $< -o $@
	$(C_COMPILER) -c $(C_FLAGS) $(INCLUDE_PATH) $< > $@.c.dep

%cpp-o: %cpp
	$(CXX_COMPILER) -c $(CXX_FLAGS) $(INCLUDE_PATH) $< -o $@
	$(CXX_COMPILER) -MM $(CXX_FLAGS) $(INCLUDE_PATH) $< > $@.cpp.dep

%s-o: %s
	$(ASM_COMPILER) -c $(ASM_FLAGS) $< -o $@

%elf: $(OBJECT_FILES) $(_TARGET_PLATFORM_FILES)
	$(C_COMPILER) $(OBJECT_FILES) $(_TARGET_LINKER_FLAGS) $(LIBS) -o $@

%hex: %elf
	$(MAKE_HEX) $< $@
	
%disasm: %elf
	$(TARGET)objdump -h -d -S $< $@

.PHONY: download
download: $(USER_PROJECT_NAME).hex
	$(ST_LINK_CLI_PATH) -Q -c SWD -P $< -V -Rst -Run
