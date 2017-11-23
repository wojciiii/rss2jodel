#!/bin/bash

#INPUT="$1"

INPUT=$(tr -dc '[[:print:]]' <<< "$1")

ESCAPED=${INPUT// /\\ }
INPUT=${ESCAPED}
ESCAPED=${INPUT//\"/\\\"}

echo $ESCAPED

#adb shell am instrument -w com.mw.autojodle/com.android.test/android.support.test.runner.AndroidJUnitRunner
adb shell am instrument -w -r\
    -e debug false -e input_string "${ESCAPED}" \
    -e class com.mw.autojodle.JodelAddTest#testJodelAddNewPost com.mw.autojodle.test/android.support.test.runner.AndroidJUnitRunner
