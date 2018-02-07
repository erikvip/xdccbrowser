#!/bin/bash

# Default location for KVIrc
LOG_DIR="${HOME}/.config/KVIrc/log";

LOG_DIR_WINDOWS="$APPDATA\KVIrc4\log"
BASEPATH=$(realpath `dirname $0`);

# Wrapper around all.sh and tabview
# This script will build a new xdcc CSV using the current KVIrc log files, 
# then launch tabview automatically

setup() {
    tabview -h 2> /dev/null 1> /dev/null
    if [[ $? != 0 ]]; then
    	echo "Error: tabview was not found and is required. Please install tabview via pip"; 
    	exit 1; 
    fi

    case "$(uname)" in
       CYGWIN*) 
           cygwin=1
           LOG_DIR="${LOG_DIR_WINDOWS}";
   	   ;;
       *)
           cygwin=0 
           ;;
    esac
    if [ ! -d "${LOG_DIR}" ]; then
    	echo "Error: could not locate KVIrc logging directory at: ${LOG_DIR}";
    	exit 1;
    fi;
    
    main
   
}


main() {
	local _csv=$(mktemp --suffix .csv -p '' xdcc.XXXXXXXXXXXXXX); 
	pushd "${LOG_DIR}" 2> /dev/null > /dev/null;
	echo "Using log files from ${LOG_DIR}."; 
#	echo "Creating XDCC CSV file at ${_csv}"; 

	$BASEPATH/all.sh . > "${_csv}"; 
	
	if [[ $? != 0 ]]; then
		echo "Error: a problem occured while generating the csv, please check output"; 
		exit 1;
	fi; 
	
	popd
	
	echo "Launching tabview browser"; 
	
	tabview --width 'mode' "${_csv}"; 
	
}



setup 






