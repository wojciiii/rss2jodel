#!/bin/bash

TOPUBLISH="$1"

echo "Publish started."

SAVED_IFS=${IFS}
IFS=''

cat ${TOPUBLISH} | while read LINE
do
    echo "Publishing \"${LINE}\""

    ( cd ../phone && ./run_test.sh "${LINE}" )

    sleep 60
done
IFS=${SAVED_IFS}

echo "Publish finished."
