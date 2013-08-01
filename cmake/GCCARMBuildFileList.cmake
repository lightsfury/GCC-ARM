if(NOT GCC_ARM_BUILD_FILE_LIST_INCLUDED)
	include(GCCARMDebugOutput)
	include(GCCARMStringConcat)

	# AdjustFileList
	# Adds a prefix and a suffix to each item in a list.
	# Places the adjusted output to the first parameter.
	function(AdjustFileList output _files prefix suffix)
		set(_adjustedFiles)
		
		# Iterate over each file in the list
		DebugOutput("AdjustFileList: Iterating over list '${_files}'.")
		foreach(l ${_files})
			# Adjust it and add it to the new list
			DebugOutput("AdjustFileList: Adding value to list '${prefix}`${l}`${suffix}'.")
			list(APPEND _adjustedFiles "${prefix}${l}${suffix}")
		endforeach()
		
		DebugOutput("AdjustFileList: Ending list '${_adjustedFiles}'.")
		# Place it in the output variable
		set(${output} ${_adjustedFiles} PARENT_SCOPE)
	endfunction()

	# ValidateFiles
	# Ensures that each item in _files exists in _validFiles.
	# Raises a fatal error if _files is not valid.
	function(ValidateFiles _files _validFiles)
		# Join _validFiles with semi-colons
		DebugOutput("ValidateFiles: Validating '${_files}' against '${_validFiles}'.")
		list(SORT _validFiles)
		StringConcat(_validFiles "${_validFiles}" ", ")
		
		foreach(file ${_files})
			if (NOT "${_validFiles}" MATCHES "${file}")
				StringConcat(_fileString "${_files}" ", ")
				message(FATAL_ERROR "ValidateFiles: Requested files contain one or more invalid files.\nValid files: ${_validFiles}\nRequested files: ${_fileString}\nInvalid file: '${file}'.")
			endif()
		endforeach()
	endfunction()

	macro(ReadFilesAndValidate _files _filesStart)
		set(_validateStart 0)
		
		DebugOutput("ReadFilesAndValidate: Checking for optional FILES sentinel")
		# Check for the optional FILES sentinel
		if("${ARGV${_filesStart}}" STREQUAL "FILES")
			DebugOutput("ReadFilesAndValidate: Checking for optional FILES sentinel - FOUND")
			set(_filesStart ${_filesStart} + 1)
		else()
			DebugOutput("ReadFilesAndValidate: Checking for optional FILES sentinel - NOT FOUND")
		endif()
		
		DebugOutput("ReadFilesAndValidate: Starting files iteration at '${_filesStart}'.")
		# Get the list of files to manipulate
		foreach(i RANGE ${_filesStart} ${ARGC})
			DebugOutput("ReadFilesAndValidate: Checking for VALIDATE sentinel")
			if("${ARGV${i}}" STREQUAL "VALIDATE") # End of file list
				DebugOutput("ReadFilesAndValidate: Checking for VALIDATE sentinel - FOUND")
				set(_validateStart ${i} + 1)
				break()
			else()
				DebugOutput("ReadFilesAndValidate: Checking for VALIDATE sentinel - NOT FOUND")
				DebugOutput("ReadFilesAndValidate: Adding file at ${i} '${ARGV${i}}'.")
				list(APPEND _files "${ARGV${i}}")
			endif()
		endforeach()
		
		# Read and validate the files if we have validation info
		if(NOT _validateStart EQUAL 0)
			foreach(i RANGE ${_validateStart} ${ARGC})
				list(APPEND _validFiles "${ARGV${i}}")
			endforeach()
			
			ValidateFiles("${_files}" "${_validFiles}")
		endif()
	endmacro()

	# BuildFileList
	# Takes a list of files, adds a prefix and a suffix and optionally validates the
	# files against alist of valid files.
	function(BuildFileList output prefix suffix)
		set(_files)
		# Read the file list, the valid file list and validate (if available)
		#ReadFilesAndValidate(_files 3)
		
		set(_filesStart 3)
		set(_validateStart 0)
		
		DebugOutput("BuildFileList: Checking for optional FILES sentinel")
		# Check for the optional FILES sentinel
		if("${ARGV${_filesStart}}" STREQUAL "FILES")
			DebugOutput("BuildFileList: Checking for optional FILES sentinel - FOUND")
			math(EXPR _filesStart "${_filesStart}+1")
		else()
			DebugOutput("BuildFileList: Checking for optional FILES sentinel - NOT FOUND")
		endif()
		
		DebugOutput("BuildFileList: Starting files iteration at '${_filesStart}'.")
		# Get the list of files to manipulate
		foreach(i RANGE ${_filesStart} ${ARGC})
			DebugOutput("BuildFileList: Checking for VALIDATE sentinel")
			if("${ARGV${i}}" STREQUAL "VALIDATE") # End of file list
				DebugOutput("BuildFileList: Checking for VALIDATE sentinel - FOUND")
				math(EXPR _validateStart "${i}+1")
				break()
			else()
				DebugOutput("BuildFileList: Checking for VALIDATE sentinel - NOT FOUND")
				DebugOutput("BuildFileList: Adding file at ${i} '${ARGV${i}}'.")
				list(APPEND _files "${ARGV${i}}")
			endif()
		endforeach()
		
		DebugOutput("BuildFileList: Checking for valid file list")
		# Read and validate the files if we have validation info
		if(NOT ${_validateStart} EQUAL 0)
			DebugOutput("BuildFileList: Checking for valid file list - FOUND")
			foreach(i RANGE ${_validateStart} ${ARGC})
				DebugOutput("BuildFileList: Adding valid file at ${i} '${ARGV${i}}'.")
				list(APPEND _validFiles "${ARGV${i}}")
			endforeach()
			
			ValidateFiles("${_files}" "${_validFiles}")
		else()
			DebugOutput("BuildFileList: Checking for valid file list - NOT FOUND")
		endif()
		
		# Add the prefix and suffix to each file in the list
		AdjustFileList(_adjustedFiles "${_files}" "${prefix}" "${suffix}")
		DebugOutput("BuildFileList: Adjusted file list '${_adjustedFiles}'.")
		# Return the file list
		set(${output} "${_adjustedFiles}" PARENT_SCOPE)
	endfunction()

	function(AddToFileList output prefix suffix)
	set(_files)
		# Read the file list, the valid file list and validate (if available)
		#ReadFilesAndValidate(_files 3)
		
		set(_filesStart 3)
		set(_validateStart 0)
		
		DebugOutput("AddToFileList: Checking for optional FILES sentinel")
		# Check for the optional FILES sentinel
		if("${ARGV${_filesStart}}" STREQUAL "FILES")
			DebugOutput("AddToFileList: Checking for optional FILES sentinel - FOUND")
			math(EXPR _filesStart "${_filesStart}+1")
		else()
			DebugOutput("AddToFileList: Checking for optional FILES sentinel - NOT FOUND")
		endif()
		
		DebugOutput("AddToFileList: Starting files iteration at '${_filesStart}'.")
		# Get the list of files to manipulate
		foreach(i RANGE ${_filesStart} ${ARGC})
			DebugOutput("AddToFileList: Checking for VALIDATE sentinel")
			if("${ARGV${i}}" STREQUAL "VALIDATE") # End of file list
				DebugOutput("AddToFileList: Checking for VALIDATE sentinel - FOUND")
				math(EXPR _validateStart "${i}+1")
				break()
			else()
				DebugOutput("AddToFileList: Checking for VALIDATE sentinel - NOT FOUND")
				DebugOutput("AddToFileList: Adding file at ${i} '${ARGV${i}}'.")
				list(APPEND _files "${ARGV${i}}")
			endif()
		endforeach()
		
		DebugOutput("AddToFileList: Checking for valid file list")
		# Read and validate the files if we have validation info
		if(NOT ${_validateStart} EQUAL 0)
			DebugOutput("AddToFileList: Checking for valid file list - FOUND")
			foreach(i RANGE ${_validateStart} ${ARGC})
				DebugOutput("AddToFileList: Adding valid file at ${i} '${ARGV${i}}'.")
				list(APPEND _validFiles "${ARGV${i}}")
			endforeach()
			
			ValidateFiles("${_files}" "${_validFiles}")
		else()
			DebugOutput("AddToFileList: Checking for valid file list - NOT FOUND")
		endif()
		
		# Add the prefix and suffix to each file in the list
		AdjustFileList(_adjustedFiles "${_files}" "${prefix}" "${suffix}")
		DebugOutput("AddToFileList: Adjusted file list '${_adjustedFiles}'.")
		# Take a snapshot of the output list
		set(outputSnapshot ${${output}})
		# Append the adjusted file list
		list(APPEND outputSnapshot ${_adjustedFiles})
		
		DebugOutput("AddToFileList: New file list '${outputSnapshot}'.")
		# Return the new file list
		set(${output} "${outputSnapshot}" PARENT_SCOPE)
	endfunction()

	set(GCC_ARM_BUILD_FILE_LIST_INCLUDED 1)
endif()
