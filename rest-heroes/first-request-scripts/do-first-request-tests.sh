#!/bin/bash
#set -eux

IMAGE=${1}
NUM_CPUS=${2}
DB_IP=${3}

echo "Testing ${IMAGE}"

for i in $(seq 1 20);
do
  sleep 2

  ./loop.sh &

  echo $CPUS
  CID=$(podman run --rm --privileged -d --memory=1g --cpus ${NUM_CPUS} --net myNetwork --ip 192.168.200.20 -p 8083:8083 \
      -e QUARKUS_DATASOURCE_REACTIVE_URL=postgresql://${DB_IP}:5433/heroes_database \
      -e QUARKUS_HIBERNATE_ORM_DATABASE_GENERATION=validate \
      -e QUARKUS_DATASOURCE_USERNAME=superman \
      -e QUARKUS_DATASOURCE_PASSWORD=superman \
      -e QUARKUS_HIBERNATE_ORM_SQL_LOAD_SCRIPT=no-file \
      -e QUARKUS_OTEL_EXPORTER_OTLP_TRACES_ENDPOINT=http://otel-collector:4317 ${IMAGE})
  sleep 5
  podman logs ${CID}

  # Grab First Response
  FR_TIME="$(head -1 output2)" # from loop.sh
  let stopMillis=$(date "+%s%N" -d "${FR_TIME}")/1000000

  #use docker inspect to get start time
  time2=$(podman inspect ${CID} | grep StartedAt | awk '{print $2}'| awk '{gsub("\"", " "); print $1}'| awk '{gsub("T"," "); print}'|awk '{print substr($0, 1, length($0)-6)}')
  time2="$time2 $( date "+%z")"
  #echo "start time"
  echo $time2
  echo $FR_TIME
  let startMillis=$(date "+%s%N" -d "$time2")/1000000
  let sutime=${stopMillis}-${startMillis}
  echo "First Response Time in ms: $sutime"

  #wait to get FP
  sleep 5
  PID=$(ps -ef | grep Dquarkus.http.host | grep -v grep | awk '{print $2}' | tail -1)
  FP=$(ps -o rss= ${PID} | numfmt --from-unit=1024 --to=iec | awk '{gsub("M"," "); print $1}')
  FP2=$(cat /proc/${PID}/smaps | grep 'Rss' | awk '{total+=$2;} END{print total;}' | numfmt --from-unit=1024 --to=iec | awk '{gsub("M"," "); print $1}')
  #echo "Footprint in MB:        : $FP"
  echo "Footprint in MB:        : $FP2"

  podman kill $CID
  podman rm $CID
done

