#!/bin/bash

BASEPATH=$(realpath `dirname $0`);

setup() {
    tabview -h 2> /dev/null 1> /dev/null
    if [[ $? != 0 ]]; then
    	echo "Error: tabview was not found and is required. Please install tabview via pip"; 
    	exit 1; 
    fi

    main "$@"
}


main() {
	local _csv=$(mktemp --suffix .csv -p '' xdcc.XXXXXXXXXXXXXX); 
	local _tmp=$(mktemp --suffix .tmp -p '' tmp.XXXXXXXXXXXXXX); 
	local _query="";
	local _search_name="";

	$BASEPATH/all.sh > "${_csv}"; 

	if [[ $? != 0 ]]; then
		echo "Error: a problem occured while generating the csv, please check output"; 
		exit 1;
	fi; 

	# Limit by search string(s), if specified
	while [ ! -z "$1" ]; do
		_query="${1/ /\|}"; 
		[ ! -z "$_search_name" ] && _search_name="${_search_name} AND ";
		_search_name="${_search_name}(${_query/|/ OR })"; 

		echo "Filtering by search string '${_query}'";
		egrep -i "${_query}" "${_csv}" > "${_tmp}";
		mv "${_tmp}" "${_csv}";  

		shift;
	done;	

	# Add the header back if it was removed during the search
	if [ ! -z "${_search_name}" ]; then
		local _header=$(awk -f "${BASEPATH}/import.awk" < /dev/null); 
		local _headersum=$(echo "${_header}" | md5sum | cut -d ' ' -f1); 
		local _checksum=$(head -n1 "${_csv}" | md5sum | cut -d ' ' -f1); 

		if [[ "${_headersum}" != "${_checksum}" ]]; then
			echo "$_header" > "${_tmp}"; 
			cat "${_csv}" >> "${_tmp}"; 
			mv "${_tmp}" "${_csv}"; 
		fi; 

	fi

	local _hits=$(cat "$_csv" | wc -l); 
	echo "Search found ${_hits} matches for ${_search_name}"; 
	
#	echo "Launching tabview browser"; 
	tabview --width 'mode' "${_csv}"; 

	rm "${_csv}" "${_tmp}" 2>/dev/null; 	
}

setup "$@"
