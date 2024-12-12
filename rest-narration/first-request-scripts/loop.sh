#!/bin/bash
#set -o xtrace

while [[ $(curl -s -o /dev/null -w ''%{http_code}'' 127.0.0.1:8087/api/narration/hello) != 200 ]] 
do
  sleep 0.001
done
date +"%Y-%m-%d %H:%M:%S.%N" > output2



