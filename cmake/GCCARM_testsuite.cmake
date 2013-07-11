
option(GCC_ARM_CMAKE_TEST_DEBUG_MESSAGES "" OFF)
option(GCC_ARM_RUN_ADJUSTFILELIST_TESTS "" OFF)
option(GCC_ARM_RUN_STRINGCONCAT_TESTS "" OFF)
option(GCC_ARM_RUN_BUILDFILELIST_TESTS "" OFF)
option(GCC_ARM_RUN_VALIDATEFILES_TESTS "" OFF)
option(GCC_ARM_RUN_ADDTOFILELIST_TESTS "" OFF)
option(GCC_ARM_RUN_LISTTOSTRING_TESTS "" OFF)

include(GCCARMBuildFileList)
include(GCCARMListToString)

if(GCC_ARM_RUN_ADJUSTFILELIST_TESTS)
	message(STATUS "Testing AdjustFileList with 1-item list")
	set(prefix1 "Z")
	set(suffix1 "-")
	set(inputList1 "abc")
	set(expectedOutput1 "Zabc-")

	AdjustFileList(output1 "${inputList1}" "${prefix1}" "${suffix1}")
	list(SORT output1)
	list(SORT expectedOutput1)


	if("${output1}" STREQUAL "${expectedOutput1}")
		message(STATUS "Testing AdjustFileList with 1-item list - PASSED")
	else()
		message(STATUS "Testing AdjustFileList with 1-item list - FAILED
	Expected: '${expectedOutput1}'
	Actual  : '${output1}'")
	endif()

	message(STATUS "Testing AdjustFileList with 3-item list")
	set(prefix2 "Libraries/STM32F10x_StdPeriph/src/stm32f10x_")
	set(suffix2 "")
	set(inputList2 PWR RCC I2C)
	set(expectedOutput2 "Libraries/STM32F10x_StdPeriph/src/stm32f10x_PWR" "Libraries/STM32F10x_StdPeriph/src/stm32f10x_RCC" "Libraries/STM32F10x_StdPeriph/src/stm32f10x_I2C")

	AdjustFileList(output2 "${inputList2}" "${prefix2}" "${suffix2}")
	list(SORT output2)
	list(SORT expectedOutput2)

	if("${output2}" STREQUAL "${expectedOutput2}")
		message(STATUS "Testing AdjustFileList with 3-item list - PASSED")
	else()
		message(STATUS "Testing AdjustFileList with 3-item list - FAILED
	Expected: '${expectedOutput2}'
	Actual  : '${output2}'")
	endif()
endif()

if(GCC_ARM_RUN_STRINGCONCAT_TESTS)
	message(STATUS "Testing StringConcat with ';' glue")
	set(glue1 ";")
	set(inputString1 abc def ghi)
	set(expectedOutputString1 "abc;def;ghi")

	StringConcat(outputString1 "${inputString1}" "${glue1}")

	if("${outputString1}" STREQUAL "${expectedOutputString1}")
		message(STATUS "Testing StringConcat with ';' glue - PASSED")
	else()
		message(STATUS "Testing StringConcat with ';' glue- FAILED
	Expected: '${expectedOutputString1}'
	Actual  : '${outputString1}'")
	endif()
endif()

if(GCC_ARM_RUN_VALIDATEFILES_TESTS)
	message(STATUS "Testing ValidateFiles with 3 input files")
	set(inputFiles1 PWR RCC I2C)
	set(validFiles ADC BKP CAN CEC CRC DAC DBGMCU DMA EXTI FLASH DSMC GPIO I2C
		IWDG PWR RCC RTC SDIO SPI TIM USART WWDG)

	ValidateFiles("${inputFiles1}" "${validFiles}")
	message(STATUS "Testing ValidateFiles with 3 input files - PASSED")
	
	message(STATUS "Testing ValidateFiles with 1 invalid input files")
	set(inputFiles2 PWR RCC I2C ASDF)

	ValidateFiles("${inputFiles2}" "${validFiles}")
	message(STATUS "Testing ValidateFiles with 1 invalid input files - FAILED")
endif()

if(GCC_ARM_RUN_BUILDFILELIST_TESTS)
	message(STATUS "Testing BuildFileList with 3-item list")
	set(prefix3 "Libraries/STM32F10x_StdPeriph/src/stm32f10x_")
	set(suffix3 ".c")
	set(inputList3 PWR RCC I2C)
	set(expectedOutput3 "Libraries/STM32F10x_StdPeriph/src/stm32f10x_PWR.c" "Libraries/STM32F10x_StdPeriph/src/stm32f10x_RCC.c" "Libraries/STM32F10x_StdPeriph/src/stm32f10x_I2C.c")

	BuildFileList(output3 "${prefix3}" "${suffix3}" FILES ${inputList3})
	list(SORT output3)
	list(SORT expectedOutput3)

	if("${output3}" STREQUAL "${expectedOutput3}")
		message(STATUS "Testing BuildFileList with 3-item list - PASSED")
	else()
		message(STATUS "Testing BuildFileList with 3-item list - FAILED
Expected: '${expectedOutput3}'
Actual  : '${output3}'")
	endif()
endif()

if(GCC_ARM_RUN_ADDTOFILELIST_TESTS)
	message(STATUS "Testing AddToFileList with 1-item list")
	set(prefix4 "Libraries/STM32F10x_StdPeriph/src/stm32f10x_")
	set(suffix4 ".c")
	set(inputList4 I2C)
	set(output4 "Libraries/STM32F10x_StdPeriph/src/stm32f10x_PWR.c" "Libraries/STM32F10x_StdPeriph/src/stm32f10x_RCC.c")
	set(expectedOutput4 "Libraries/STM32F10x_StdPeriph/src/stm32f10x_PWR.c" "Libraries/STM32F10x_StdPeriph/src/stm32f10x_RCC.c" "Libraries/STM32F10x_StdPeriph/src/stm32f10x_I2C.c")

	AddToFileList(output4 "${prefix4}" "${suffix4}" FILES ${inputList4})
	list(SORT output4)
	list(SORT expectedOutput4)

	if("${output4}" STREQUAL "${expectedOutput4}")
		message(STATUS "Testing AddToFileList with 1-item list - PASSED")
	else()
		message(STATUS "Testing AddToFileList with 1-item list - FAILED
Expected: '${expectedOutput4}'
Actual  : '${output4}'")
	endif()
endif()

if(GCC_ARM_RUN_LISTTOSTRING_TESTS)
	message(STATUS "Testing ListToString with 2-item list")
	set(list1 "Assert;SizeOpt")
	set(expectedString1 "\"Assert\" \"SizeOpt\"")
	
	ListToString(outputString1 ${list1})
	
	if("${outputString1}" STREQUAL "${expectedString1}")
		message(STATUS "Testing ListToString with 2-item list - PASSED")
	else()
		message(STATUS "Testing ListToString with 2-item list - FAILED
Expected: '${expectedString1}'
Actual  : '${outputString1}'")
	endif()
	
endif()
