#!/bin/bash

# File used to store hashes:
HASH_FILE="hashes"

touch "${HASH_FILE}"

# read feeds from input.rss and store the result to output.txt
./readrss.py -i input.rss -o output.txt

# get unique strings:
SAVED_IFS=${IFS}
IFS=''

cat output.txt | while read LINE
do
    #echo "LINE=${LINE}"
    FIRST=$(echo ${LINE}| cut -d ":" -f 1)
    #echo ${FIRST}
    grep -c "${FIRST}" ${HASH_FILE} &> /dev/null
    RET=$?
    if [[ "${RET}" -ne "0" ]]; then
        SECOND=$(echo ${LINE}| cut -d ":" -f 2-)
        echo "New line:${SECOND}"
        echo "${FIRST}" >> "${HASH_FILE}"
    fi
done
IFS=${SAVED_IFS}
