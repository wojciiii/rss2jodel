#!/bin/bash

DEBUG=1

TOPUBLISH="$1"

if [[ "${DEBUG}" == "1" ]]; then
    echo "Publish started."
fi

SAVED_IFS=${IFS}
IFS=''

CONTENTS=$()

declare -a FIRST_BASES=()
declare -a SECOND_BASES=()

while read LINE
do
    if [[ "${DEBUG}" == "1" ]]; then
        echo "Publishing \"${LINE}\""
    fi
    FIRST=$(echo ${LINE}| cut -d ":" -f 1)
    SECOND=$(echo ${LINE}| cut -d ":" -f 2-)

    BASE64=$(echo "${FIRST}" | base64 -w 0)
    FIRST_BASES+=("${BASE64}")
    BASE64=$(echo "${SECOND}" | base64 -w 0)
    SECOND_BASES+=("${BASE64}")
done <<< "$(cat ${TOPUBLISH})"

IFS=${SAVED_IFS}

#COUNT_MAX=${COUNT}

cd ../phone

for index in ${!FIRST_BASES[*]}; do
    if [[ "${DEBUG}" == "1" ]]; then
        echo "${index}"
        echo "run_test.sh ${FIRST_BASES[$index]} ${SECOND_BASES[$index]}"
        ./run_test.sh "${FIRST_BASES[$index]}" "${SECOND_BASES[$index]}"
        sleep 60
        #exit 0
    else
        ./run_test.sh "${FIRST_BASES[$index]}" "${SECOND_BASES[$index]}"
    fi
done

if [[ "${DEBUG}" == "1" ]]; then
    echo "Publish finished."
fi

exit 0
