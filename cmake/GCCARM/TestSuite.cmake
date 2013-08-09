
option(GCC_ARM_CMAKE_RUN_TEST_JoinList "Run test suite for JoinList." OFF)
option(GCC_ARM_CMAKE_RUN_TEST_ModifyList "Run test suite for ModifyList." OFF)
option(GCC_ARM_CMAKE_RUN_TEST_VerifyList "Run test suite for VerifyList." OFF)

function(Test_JoinList)
	message(STATUS "Running tests for JoinList")
	
	message(STATUS "Test Case: JoinList with 2 item list")
	set(inputList "Assert;SizeOpt")
	set(expectedString "Assert SizeOpt")
	set(inputGlue " ")
	
	JoinList(outputString ${inputGlue} "${inputList}")
	
	if(outputString STREQUAL expectedString)
		message(STATUS "Test Case: JoinList with 2 item list - PASSED")
	else()
		message(STATUS "Test Case: JoinList with 2 item list - FAILED\nExpected: '${expectedString}'\nActual  : '${outputString}'")
	endif()
	
	message(STATUS "Test Case: JoinList with 2 items")
	set(expectedString "Assert SizeOpt")
	set(inputGlue " ")
	
	JoinList(outputString ${inputGlue} Assert SizeOpt)
	
	if(outputString STREQUAL expectedString)
		message(STATUS "Test Case: JoinList with 2 items - PASSED")
	else()
		message(STATUS "Test Case: JoinList with 2 items - FAILED\nExpected: '${expectedString}'\nActual  : '${outputString}'")
	endif()
	
	message(STATUS "Running tests for JoinList - DONE")
endfunction()

function(Test_ModifyList)
	message(STATUS "Running tests for ModifyList")
	
	message(STATUS "Test Case: ModifyList with prefix")
	set(inputList "Assert;SizeOpt")
	set(inputPrefix "DebugOptions/")
	set(inputSuffix "")
	set(expectedString "DebugOptions/Assert DebugOptions/SizeOpt")
	set(inputGlue " ")
	
	ModifyList(inputList "${inputPrefix}" "${inputSuffix}")
	JoinList(outputString ${inputGlue} ${inputList})
	
	if(outputString STREQUAL expectedString)
		message(STATUS "Test Case: ModifyList with prefix - PASSED")
	else()
		message(STATUS "Test Case: ModifyList with prefix - FAILED\nExpected: '${expectedString}'\nActual  : '${outputString}'")
	endif()
	
	message(STATUS "Test Case: ModifyList with suffix")
	set(inputList "Assert;SizeOpt")
	set(inputPrefix "")
	set(inputSuffix ".cmake")
	set(expectedString "Assert.cmake SizeOpt.cmake")
	set(inputGlue " ")
	
	ModifyList(inputList "${inputPrefix}" "${inputSuffix}")
	JoinList(outputString ${inputGlue} ${inputList})
	
	if(outputString STREQUAL expectedString)
		message(STATUS "Test Case: ModifyList with prefix - PASSED")
	else()
		message(STATUS "Test Case: ModifyList with prefix - FAILED\nExpected: '${expectedString}'\nActual  : '${outputString}'")
	endif()
	
	message(STATUS "Running tests for ModifyList - DONE")
endfunction()

function(Test_VerifyList)
	message(STATUS "Running tests for VerifyList")
	
	message(STATUS "Test Case: VerifyList with extra valid items")
	set(inputList "Assert;SizeOpt")
	set(validList "Assert;SizeOpt;DebugOpt")
	
	VerifyList(listIsValid "${validList}" ${inputList})
	
	if(listIsValid)
		message(STATUS "Test Case: VerifyList with extra valid items - PASSED")
	else()
		message(STATUS "Test Case: VerifyList with extra valid items - FAILED")
	endif()
	
	message(STATUS "Test Case: VerifyList with invalid items")
	set(inputList "Assert;SizeOpt;DebugOpt")
	set(validList "Assert;SizeOpt")
	
	VerifyList(listIsValid "${validList}" "${inputList}")
	
	if(NOT listIsValid)
		message(STATUS "Test Case: VerifyList with invalid items - PASSED")
	else()
		message(STATUS "Test Case: VerifyList with invalid items - FAILED")
	endif()
	
	message(STATUS "Running tests for VerifyList - DONE")
endfunction()

if(GCC_ARM_CMAKE_RUN_TEST_JoinList)
	Test_JoinList()
endif()

if(GCC_ARM_CMAKE_RUN_TEST_ModifyList)
	Test_ModifyList()
endif()

if(GCC_ARM_CMAKE_RUN_TEST_VerifyList)
	Test_VerifyList()
endif()
