#!/bin/bash
# Match XDCC lines:
#cat channel_#the%2esource.scenep2p_2017.01.17.log | cut -d ' ' -f3- | sed -r 's/^<\+([^>])*>/&/g' | grep '^<[^>]*> \#[0-9]* *[0-9]*x \[[\.0-9KMG ]*\]' | sort | uniq | sed -r 's/\[ /[/g'


#zenity --list --width 800 --height 600  --title "WTF" --column="#" --column="File" --column="Nick" --column="Type" --column="Size" --separator=$'\t' $(sqlite3 --separator $'\t' xdcc.sqlite3 "select number, file, nick, hint, size from packs order by file")
NETWORK='abjects'
CHANNEL='#moviegods'

TOTALLINES=0;
PROCESSED=0;
last="";

splitline() {
	
	(( PROCESSED++ ));

	local _progress=$(echo "${PROCESSED} / ${TOTALLINES}" | bc -l | xargs printf "%0.2f");
	

	if [ "${_progress}" != "${last}" ]; then
		echo -ne "\r${PROCESSED} of ${TOTALLINES} processed. ${_progress}%";
	fi
	last="${_progress}";

	local _nick=$(echo "$1" | sed -r -e 's/^<\+?//g' -e 's/>$//g');
	local _number=$(echo "$2" | sed -r -e 's/^#//g');
	local _requests=$(echo "$3" | sed -r -e 's/x$//g');
	local _size=$(echo "$4" | tr -d '[] ' | numfmt --from=iec);
	local _file=$5;

	local _hint=$(typehint "$_nick" $_size "$_file");

    #CREATE TABLE packs (network varchar(255), channel varchar(255), nick varchar(255), number int, requests int, size varchar(15), file varchar(255), logfile varchar(255));
	#echo -e "$_hint \t $_file \t $_size \t $_nick";
	#CREATE TABLE packs (network varchar(255), channel varchar(255), nick varchar(255), number int, requests int, size varchar(15), file varchar(255), hint varchar(16), logfile varchar(255));

	local _sql="REPLACE INTO packs VALUES('${NETWORK}', '${CHANNEL}', '${_nick}', '${_number}', '${_requests}', '${_size}', '${_file}', '${_hint}', 'test' );";
	#echo $_sql;
	#echo $_sql >> fuck.sql
	sqlite3 xdcc.sqlite3 "$_sql";

}

parsefile() {
	local _logfile=${1:-};


	if [ ! -e "${_logfile}" ]; then
		echo "No log file specified";
		exit 1;
	fi



#	TOTALLINES=$(cat "${_logfile}" | wc -l);

#	IFS=$'\n';
#	local _count=0

#	for line in $(cat "${_logfile}"); do
#		IFS=$' ';
		#splitline $line
#		((_count++))
#		echo "${_count}"
 #       typehint $line
#	done	
}


typehint() {
	local _nick=$1
	local _size=$2
	local _file=$3
	

	local _hint="unknown";

	# Check for TV Episode
	echo "$_file" | egrep -q 'S[0-9]*E[0-9]*'
	[ $? -eq 0 ] && _hint="TV";
	echo "$_file" | egrep -q 'HDTV'
	[ $? -eq 0 ] && _hint="TV";


	echo "$_file" | egrep -q 'XXX'
	[ $? -eq 0 ] && _hint="XXX";

	echo "$_file" | egrep -qi 'EBOOK'
	[ $? -eq 0 ] && _hint="EBOOK";

	echo "$_file" | egrep -qi 'Android'
	[ $? -eq 0 ] && _hint="APP";

    if [[ "$_hint" == "unknown" ]]; then
        echo "$_file" | egrep -qi '(\.BlueRay\.|\.X264\.|\.H264\.|\.HDRIP\.|\.BDRIP\.|mkv)'
        [ $? -eq 0 ] && _hint="MOVIES";


        echo "$_nick" | egrep -q 'APP'
        [ $? -eq 0 ] && _hint="APP";

    fi

	# Guess by file size...over 500MB we're gonna say are movies
#	if [[ "$_hint" == "unknown" && $_size > 500000000 ]]; then
#		_hint="MOVIES";
#	fi


	echo $_hint;
	
	
}

parsefile $@