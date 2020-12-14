#!/bin/bash -x

NETWORK=${1:?usage $0 <network name> <channel name - NO '#'>};
CHANNEL=${2:?usage $0 <network name> <channel name - NO '#'>};
SKIPHEADER=${3:-0};

#(>&2 echo "Reading input from stdin (you must send the file(s) to stdin...)")

BASEDIR=$(dirname $0);


#tr -dc "_A-Z-a-z-0-9 :#_\-\.\n\[\]\|" | cut -d ' ' -f3- | egrep -v ' has (joined|left|quit)'  | egrep '^\#[0-9]+' \
tr -dc "_A-Z-a-z-0-9 :#_\-\.\n\[\]\|" | cut -d ' ' -f2- | egrep -v ' has (joined|left|quit)' | egrep '^[^ ]* \#[0-9]+' \
    | grep -vi '.German.' \
    | grep -vi '.French.' \
	| sed -r -e 's/ \[([ 0-9\.MGKmgk]*)\] / \1 /g' -e 's/ \#([0-9]*) / \1 /g' -e 's/ +([0-9]+)x/ \1/g' \
    | sort | uniq \
    | awk -v NETWORK="${NETWORK}" -v CHANNEL="${CHANNEL}" -v SKIPHEADER="${SKIPHEADER}" -F ' ' -f "${BASEDIR}/import.awk"


    # > "${OUTPUT}"


#cat "${OUTPUT}";
    

