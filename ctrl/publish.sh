#!/bin/bash

TOPUBLISH="$1"

echo "Publish started."

SAVED_IFS=${IFS}
IFS=''

cat ${TOPUBLISH} | while read LINE
do
    echo "Publishing \"${LINE}\""
    sleep 10
done
IFS=${SAVED_IFS}

echo "Publish finished."
