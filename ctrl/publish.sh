#!/bin/bash

TOPUBLISH="$1"

echo "Publish started."

SAVED_IFS=${IFS}
IFS=''

CONTENTS=$()

declare -a BASES=()
while read LINE
do
    echo "Publishing \"${LINE}\""
    BASE64=$(echo "${LINE}" | base64 -w 0)
    BASES+=("${BASE64}")
done <<< "$(cat ${TOPUBLISH})"

#COUNT_MAX=${COUNT}

cd ../phone

for B in ${BASES[@]}; do
    echo "${B}"
    ./run_test.sh "${B}"
    sleep 60
done

echo "Publish finished."

exit 0
