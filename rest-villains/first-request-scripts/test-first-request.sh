#!/bin/bash

LOG_FILE="${1//\//_}.log"

echo "TESTING ${1} on ${2} cpu(s). See logs/${LOG_FILE}"
killall loop.sh

./do-first-request-tests.sh ${1} ${2} ${3} > logs/$LOG_FILE
./parse.sh logs/$LOG_FILE
