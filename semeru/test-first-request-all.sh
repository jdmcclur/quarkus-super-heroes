#!/bin/bash
cd "$(dirname "$0")"

if [[ ${1} == "" ]]
then
  echo "Please specifiy IP address of backend services."
  exit
fi

cd ../rest-fights/first-request-scripts
./test-first-request.sh rest-fights:semeru 1 ${1}
./test-first-request.sh quay.io/quarkus-super-heroes/rest-fights:native-latest 1 ${1}

cd ../../rest-heroes/first-request-scripts
./test-first-request.sh rest-heroes:semeru 1 ${1}
./test-first-request.sh quay.io/quarkus-super-heroes/rest-heroes:native-latest 1 ${1}

cd ../../rest-narration/first-request-scripts
./test-first-request.sh rest-narration:semeru 1
./test-first-request.sh quay.io/quarkus-super-heroes/rest-narration:native-latest 1

cd ../../rest-villains/first-request-scripts
./test-first-request.sh rest-villains:semeru 1 ${1}
./test-first-request.sh quay.io/quarkus-super-heroes/rest-villains:native-latest 1 ${1}



