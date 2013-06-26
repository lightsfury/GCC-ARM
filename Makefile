# Copyright (c) 2013 Robert Beam
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Include user configuration data
-include ./device.conf

# Include platform dependent variables
-include ./platform.d/$(USER_DEVICE_CLASS)/Makefile

# @section Build variables
TARGET			= $(TOOLCHAIN_ROOT_PATH)arm-none-eabi-
C_COMPILER		= $(TARGET)gcc
CXX_COMPILER	= $(TARGET)g++
ASM_COMPILER	= $(TARGET)g++ -x assembler-with-cpp
MAKE_HEX		= $(TARGET)objcopy -O ihex
MAKE_BIN		= $(TARGET)objcopy -O binary -S

SOURCE_FILES	= $(USER_CXX_FILES) $(USER_C_FILES) $(USER_ASM_FILES)
C_FILES			= $(filter %.c, $(SOURCE_FILES))
CXX_FILES		= $(filter %.cpp, $(SOURCE_FILES))
ASM_FILES		= $(filter %.s, $(SOURCE_FILES))

OBJECT_FILES	:= $(realpath $(addprefix $(BUILD_PATH), $(C_FILES:.c=.c-o) $(CXX_FILES:.cpp=.cpp-o) $(ASM_FILES:.s=.s-o))) $(_TARGET_CORE_OBJECT_FILES)
LIBS			= $(USER_LIBRARIES)

REAL_BUILD_PATH	= $(realpath $(BUILD_PATH))/

INCLUDE_PATH	= $(patsubst %, "-I%", $(USER_INCLUDE_PATH) $(_TARGET_INCLUDE_PATH))
LIBRARY_PATH	= $(patsubst %, "-L%", $(USER_LIBRARY_PATH) $(_TARGET_LIBRARY_PATH))

ASM_FLAGS		= $(_TARGET_COMPILER_FLAGS) $(USER_ASM_DEFINES)
C_FLAGS			= $(_TARGET_COMPILER_FLAGS)	$(USER_C_DEFINES) -Wall
CXX_FLAGS		= $(_TARGET_COMPILER_FLAGS) $(USER_CXX_DEFINES) -Wall

ifeq ($(INCLUDE_LIBC),1)
ifeq ($(LIBC_USE_RDIMON),1)
LIBS	+= -lrdimon -lc -lgcc -lrdimon
else
LIBS	+= -lnosys -lc -lgcc -lnosys
endif
# ifeq LIBC_USE_RDIMON
endif

# @section Build targets
.SECONDEXPANSION:

all: $(OBJECT_FILES) $(OUTPUT_PATH)$(USER_PROJECT_NAME).elf $(OUTPUT_PATH)$(USER_PROJECT_NAME).hex $(OUTPUT_PATH)$(USER_PROJECT_NAME).bin $(OUTPUT_PATH)$(USER_PROJECT_NAME).disasm
	$(TARGET)size $(OUTPUT_PATH)$(USER_PROJECT_NAME).elf

$(REAL_BUILD_PATH)%c-o: %c $$(@D)/.d
	$(C_COMPILER) -c $(C_FLAGS) $(INCLUDE_PATH) $< -o $@

$(REAL_BUILD_PATH)%cpp-o: %cpp $$(@D)/.d
	$(CXX_COMPILER) -c $(CXX_FLAGS) $(INCLUDE_PATH) $< -o $@

$(REAL_BUILD_PATH)%s-o: %s $$(@D)/.d
	$(ASM_COMPILER) -c $(ASM_FLAGS) $< -o $@

%elf: $(OBJECT_FILES) $(_TARGET_PLATFORM_FILES) $$(@D)/.d
	$(C_COMPILER) $(_TARGET_LINKER_FLAGS) $(LIBRARY_PATH) $(LIBS) $(OBJECT_FILES) $(LIBS) -o $@

%hex: %elf $$(@D)/.d
	$(MAKE_HEX) $< $@

%bin: %elf $$(@D)/.d
	$(MAKE_BIN) $< $@

%disasm: %elf $$(@D)/.d
	$(TARGET)objdump -h -d -S $< > $@

.PRECIOUS: %/.d

%/.d:
	mkdir "$(dir $@)"
	touch "$@"

.PHONY: clean
clean:
	rm -R $(REAL_BUILD_PATH)
	rm -R $(OUTPUT_PATH)

.PHONY: download
download: $(OUTPUT_PATH)$(USER_PROJECT_NAME).hex
	$(DEVICE_PROGRAM_COMMAND) $<
	#$(ST_LINK_CLI_PATH) -Q -c SWD -P $< -V -Rst -Run

.PHONY: start-openocd
start-openocd:
	$(START_DEBUG_COMMAND)
	
	
debug:
	@echo $(LIBRARY_PATH)
	@echo $(LIBS)
