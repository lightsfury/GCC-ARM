if(NOT GCC_ARM_PARSE_DEBUG_LEVEL_INCLUDED)
	include(GCCARMBuildFileList)

	set(VALID_DEBUG_OPTS
		Assert
	#	DebugOpt
		SizeOpt)

	BuildFileList(DEBUG_OPTS_INCLUDES "DebugLevel/" ""
		FILES ${GCC_ARM_DEBUG_OPTIONS} VALIDATE ${VALID_DEBUG_OPTS})

	foreach(level ${DEBUG_OPTS_INCLUDES})
		include(${level})
	endforeach()

	set(GCC_ARM_PARSE_DEBUG_LEVEL_INCLUDED 1)
endif()
