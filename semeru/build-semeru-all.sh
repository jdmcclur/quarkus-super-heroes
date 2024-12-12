#!/bin/bash
cd "$(dirname "$0")"

if [[ ${1} == "" ]]
then
  echo "Please specifiy IP address of backend services."
  exit
fi

cd ../grpc-locations/semeru
./build-semeru.sh ${1}

cd ../../rest-fights/semeru
./build-semeru.sh ${1}

cd ../../rest-heroes/semeru
./build-semeru.sh ${1}

cd ../../rest-narration/semeru
./build-semeru.sh

cd ../../rest-villains/semeru
./build-semeru.sh ${1}



