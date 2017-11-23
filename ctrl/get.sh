#!/bin/bash

# File used to store hashes:
HASH_FILE="hashes"
# Where to write the found topics:
TEMP_OUTPUT="output/temp.txt"

NOW=$(date +%s)
TOPICS="output/topics-${NOW}"
echo "Creating ${TOPICS}"

#rm -f "${HASH_FILE}"

touch "${HASH_FILE}"

mkdir -p output
rm -f ${TEMP_OUTPUT}

# read feeds from input.rss and store the result to output.txt
./readrss.py -i input.rss -o ${TEMP_OUTPUT}

# get unique strings:
SAVED_IFS=${IFS}
IFS=''

cat ${TEMP_OUTPUT} | while read LINE
do
    FIRST=$(echo ${LINE}| cut -d ":" -f 1)
    grep -c "${FIRST}" ${HASH_FILE} &> /dev/null
    RET=$?
    if [[ "${RET}" -ne "0" ]]; then
        SECOND=$(echo ${LINE}| cut -d ":" -f 2-)
        echo "New:${SECOND}"
        echo "(nyhed) ${SECOND}" >> "${TOPICS}"
        echo "${FIRST}" >> "${HASH_FILE}"
    fi
done
IFS=${SAVED_IFS}

if [[ -e "${TOPICS}" ]]; then
    COUNT=$(wc -l ${TOPICS} | cut -d " " -f1)
    echo "Jodling ${COUNT} topic(s) from ${TOPICS}"
    ./publish.sh "${TOPICS}" &
    exit 0
fi
