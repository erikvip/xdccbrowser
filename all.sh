#!/bin/bash

BASEPATH=$(realpath `dirname $0`);
FILEDIR=${1:-"$BASEPATH"};

(>&2 echo "Processing all channel_*.log files from ${FILEDIR}")

process() {
    f="$1"

    ((PROCESSED++));

    [ "${PROCESSED}" -gt 1 ] && (>&2 echo -ne  );

    FILE=$(basename "$f");
    CHANNEL=$(echo "${FILE}" | cut -d '#' -f2 | cut -d '.' -f1);
    NETWORK=$(echo "{$FILE}" | cut -d "." -f2 | cut -d '_' -f1);
    (>&2 echo -ne "\r\033[2KProcessing ${CHANNEL} from ${NETWORK}.");

    cat "${f}" | "${BASEPATH}/parse.sh" "${NETWORK}" "${CHANNEL}" 

}
export -f process
export BASEPATH
find "${FILEDIR}" -maxdepth 1 -type f -iname 'channel_*.log' -exec bash -c 'process "$0"' {} \;

(>&2 echo )

