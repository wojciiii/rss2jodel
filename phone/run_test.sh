#!/bin/bash

adb shell "am instrument -w -r -e debug false -e input_string1 $1 -e input_string2 $2 -e class com.mw.autojodle.JodelAddTest#testJodelAddNewPost com.mw.autojodle.test/android.support.test.runner.AndroidJUnitRunner"
RET=$?
echo "RET=${RET}"

exit 0

