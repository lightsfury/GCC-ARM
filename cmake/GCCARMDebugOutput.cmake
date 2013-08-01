if(NOT GCC_ARM_DEBUG_OUTPUT)
	function(DebugOutput msg)
		if(GCC_ARM_CMAKE_DEBUG_MESSAGES)
			message(STATUS ${msg})
		endif()
	endfunction()

	set(GCC_ARM_DEBUG_OUTPUT 1)
endif()
