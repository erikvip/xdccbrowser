#!/bin/bash
#tr -dc "_A-Z-a-z-0-9 :#_\-\.\n"
tr -dc "_A-Z-a-z-0-9 :#_\-\.\n\[\]" | cut -d ' ' -f3- | sort | uniq | egrep -v ' has (joined|left|quit)'
