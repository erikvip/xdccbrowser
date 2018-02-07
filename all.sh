#!/bin/bash

# Default location for KVIrc
LOG_DIR="${HOME}/.config/KVIrc/log";
LOG_DIR_WINDOWS="$APPDATA\KVIrc4\log"
BASEPATH=$(realpath `dirname $0`);

# Use the windows path if we're on Cygwin
[ `uname -o` == "Cygwin" ] && LOG_DIR="${LOG_DIR_WINDOWS}"; 

# If $1 was passed, and is a valid path, use it instead
[ ! -z "${1}" ] && LOG_DIR="${1}"; 

# Verify the log directory exists
[ ! -d "${LOG_DIR}" ] && echo "Error: could not locate log file directory at ${LOG_DIR}" && exit 1; 

(>&2 echo "Processing all channel_*.log files from ${LOG_DIR}")

process() {
    f="$1"

    ((PROCESSED++));

    [ "${PROCESSED}" -gt 1 ] && (>&2 echo -ne  );

    FILE=$(basename "$f");
    CHANNEL=$(echo "${FILE}" | cut -d '#' -f2 | cut -d '.' -f1);
    NETWORK=$(echo "{$FILE}" | cut -d "." -f2 | cut -d '_' -f1);
    (>&2 echo -ne "\r\033[2KProcessing ${CHANNEL} from ${NETWORK}.");

    cat "${f}" | "${BASEPATH}/parse.sh" "${NETWORK}" "${CHANNEL}" "1"

}
export -f process
export BASEPATH

# Run the awk script once with no input, to output the row header. All subseqent calls will have SKIPHEADER set
awk -f "${BASEPATH}/import.awk" < /dev/null

find "${LOG_DIR}" -maxdepth 1 -type f -ctime -5 -iname 'channel_*.log' -exec bash -c 'process "$0"' {} \;

(>&2 echo )

