#!/bin/bash
tr -dc "_A-Z-a-z-0-9 :#_\-\.\n\[\]\|" | cut -d ' ' -f3- | egrep -v ' has (joined|left|quit)'  | egrep '^[^ ]* \#[0-9]+' \
    | grep -vi '.German.' \
    | grep -vi '.French.' \
	| sed -r -e 's/\[([ 0-9\.MGKmgk]*)\]/\1/g' -e 's/ \#([0-9]*) / \1 /g' -e 's/ +([0-9]+)x/ \1/g' \
    | sort | uniq \
    | awk -v NETWORK='abjects' -v CHANNEL='#moviegods' -F ' ' -f importsql.awk

