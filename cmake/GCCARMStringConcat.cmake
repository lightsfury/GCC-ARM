if(NOT GCC_ARM_STRING_CONCAT_INCLUDED)

function(StringConcat output _list glue)
# Iterate over each item in _list
#   Replace instances of ; with ###
#   Glue the piece to back of the new string
# Replace ### with ;
	DebugOutput("StringConcat: Joining list '${_list}' with '${glue}'.")
	set(_newList)
	
	foreach(i ${_list})
		DebugOutput("StringConcat: Adding '${i}'.")
		set(_newList "${_newList}${glue}${i}")
	endforeach()
	
	DebugOutput("StringConcat: Trimming glue from '${_newList}'.")
	string(REGEX REPLACE "^${glue}(.*)$" "\\1" _newList "${_newList}")
	
	set(${output} "${_newList}" PARENT_SCOPE)
endfunction()

set(GCC_ARM_STRING_CONCAT_INCLUDED 1)
endif()
