#!/bin/bash

if [[ ${1} == "" ]] 
then
  echo "Please specifiy IP address for Heroes DB."
  exit
fi

podman build -f Dockerfile.semeru -t rest-heroes:semeru-step1 --build-arg=REMOTE_IP=${1} ../
podman run --replace --name rest-heroes-semeru-checkpoint-run --privileged --cpus 1 -m 1G --net myNetwork --net myNetwork --ip 192.168.200.20 -p 8083:8083 rest-heroes:semeru-step1
podman commit rest-heroes-semeru-checkpoint-run rest-heroes:semeru
podman rm rest-heroes-semeru-checkpoint-run

