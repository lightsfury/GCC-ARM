if(NOT GCC_ARM_PARSE_DEBUG_LEVEL_INCLUDED)
	include(GCCARMBuildFileList)

	set(VALID_DEBUG_LEVELS
		Assert
	#	DebugOpt
		SizeOpt)

	BuildFileList(DEBUG_LEVEL_INCLUDES "DebugLevel/" ""
		FILES ${DEBUG_LEVEL} VALIDATE ${VALID_DEBUG_LEVELS})

	foreach(level ${DEBUG_LEVEL_INCLUDES})
		include(${level})
	endforeach()

	set(GCC_ARM_PARSE_DEBUG_LEVEL_INCLUDED 1)
endif()
