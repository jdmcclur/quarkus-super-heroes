#!/bin/bash

if [[ ${1} == "" ]] 
then
  echo "Please specifiy IP address for Fight DB."
  exit
fi

podman build -f Dockerfile.semeru -t rest-fights:semeru-step1 --build-arg=REMOTE_IP=${1} ../
podman run --replace --name rest-fights-semeru-checkpoint-run --privileged --cpus 1 -m 1G --net myNetwork --net myNetwork --ip 192.168.200.22 -p 8082:8082 rest-fights:semeru-step1
podman commit rest-fights-semeru-checkpoint-run rest-fights:semeru
podman rm rest-fights-semeru-checkpoint-run

