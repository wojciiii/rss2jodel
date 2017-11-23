#!/bin/bash

IP="192.168.2.60"
PORT="5556"

adb tcpip ${PORT}
adb connect ${IP}:${PORT}
#adb disconnect ${IP}:${PORT}
