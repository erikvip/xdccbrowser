#!/bin/bash -e

main () {
    if [[ -e "~/xdcclog/lists/all.tar" ]]; then
        rm ~/xdcclog/lists/all.tar
    fi
    tar cf ~/xdcclog/lists/all.tar -T /dev/null
    source "xdcc-config.sh";
    

}

cleanup_logs() {
    for f in $(ls *.log | grep -v '^#'); do echo rm $f; done
    echo rm *-chat.log
}

process_xdcc() {
    _logfile=$1;
    _network=$2;
    _channel=$3;
    if [[ `stat -c '%s' "${_logfile}"` -gt 100000000 ]]; then 
        echo "Truncating ${_logfile} to last 1mil lines";
        tail -n 1000000 "${_logfile}" | sponge "${_logfile}"
    fi
    cat "${_logfile}" | ~/work/xdccbrowser/parse.sh "${_network}" "${_channel}" | gzip > ~/xdcclog/lists/${_network}-${_channel}.csv.gz

    echo "Output saved to ~/xdcclog/lists/${_network}-${_channel}.csv.gz";
    tar rf ~/xdcclog/lists/all.tar ~/xdcclog/lists/${_network}-${_channel}.csv.gz
}

###
# Add an xdcc channel to monitor
# $1 path to log file
# $2 chatnet nane (from irssi config)
# $3 channel name 

#
addchannel() {
    local _logfile="$1";
	local _net="$2";
	local _channel="$3";

	pushd `dirname "${_logfile}"`

	# cleanup_logs

	process_xdcc "${_logfile}" "${_net}" "${_channel}"
	popd
}

main




