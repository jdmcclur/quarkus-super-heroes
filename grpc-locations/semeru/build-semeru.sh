#!/bin/bash

if [[ ${1} == "" ]]
then
  echo "Please specifiy IP address for Locations DB."
  exit
fi

podman build -f Dockerfile.semeru -t grpc-locations:semeru-step1  --build-arg=REMOTE_IP=${1} ../
podman run --replace --name grpc-locations-semeru-checkpoint-run --privileged --cpus 1 -m 1G --net myNetwork --net myNetwork --ip 192.168.200.24 -p 8089:8089 grpc-locations:semeru-step1
podman commit grpc-locations-semeru-checkpoint-run grpc-locations:semeru
podman rm grpc-locations-semeru-checkpoint-run

