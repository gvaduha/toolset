#! /bin/bash

set LOG-FILE-NAME=$1
set TMP-CSV-NAME=$2

grep -i "ing to elvis" LOG-FILE-NAME sed 's/-/:/gp' | sed -rn 's/([0-9 \:]+)\..*room=([0-9]+).*pot=([0-9]+).*new_val=([0-1]).*/\1,\2,\3,\4/p' > TMP-CSV-NAME
