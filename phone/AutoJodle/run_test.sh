#!/bin/bash

#adb shell am instrument -w com.mw.autojodle/com.android.test/android.support.test.runner.AndroidJUnitRunner
adb shell am instrument -w -r -e debug false -e class com.mw.autojodle.JodelAddTest#checkPreconditions com.mw.autojodle.test/android.support.test.runner.AndroidJUnitRunner
