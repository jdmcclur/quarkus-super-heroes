#!/bin/bash

if [[ ${1} == "" ]] 
then
  echo "Please specifiy IP address for Villains DB."
  exit
fi

podman build -f Dockerfile.semeru -t rest-villains:semeru-step1 --build-arg=REMOTE_IP=${1} ../
podman run --replace --name rest-villains-semeru-checkpoint-run --privileged --cpus 1 -m 1G --net myNetwork --net myNetwork --ip 192.168.200.21 -p 8084:8084 rest-villains:semeru-step1
podman commit rest-villains-semeru-checkpoint-run rest-villains:semeru
podman rm rest-villains-semeru-checkpoint-run

