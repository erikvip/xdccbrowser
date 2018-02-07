#!/bin/bash

BASEPATH=$(realpath `dirname $0`);

setup() {
    tabview -h 2> /dev/null 1> /dev/null
    if [[ $? != 0 ]]; then
    	echo "Error: tabview was not found and is required. Please install tabview via pip"; 
    	exit 1; 
    fi

    main
}


main() {
	local _csv=$(mktemp --suffix .csv -p '' xdcc.XXXXXXXXXXXXXX); 
	
	$BASEPATH/all.sh > "${_csv}"; 
	
	if [[ $? != 0 ]]; then
		echo "Error: a problem occured while generating the csv, please check output"; 
		exit 1;
	fi; 
	
	echo "Launching tabview browser"; 
	tabview --width 'mode' "${_csv}"; 

	rm "${_csv}"; 	
}

setup 






