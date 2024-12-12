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

  CID=$(podman run --rm --privileged -d --memory=1g --cpus ${NUM_CPUS} --net myNetwork --ip 192.168.200.22 -p 8082:8082 \
  -e QUARKUS_MONGODB_HOSTS=${DB_IP}:27017 \
  -e KAFKA_BOOTSTRAP_SERVERS=PLAINTEXT://${DB_IP}:9092 \
  -e QUARKUS_LIQUIBASE_MONGODB_MIGRATE_AT_START="false" \
  -e QUARKUS_MONGODB_CREDENTIALS_USERNAME=superfight \
  -e QUARKUS_MONGODB_CREDENTIALS_PASSWORD=superfight \
  -e QUARKUS_STORK_HERO_SERVICE_SERVICE_DISCOVERY_ADDRESS_LIST=rest-heroes:8083 \
  -e QUARKUS_STORK_VILLAIN_SERVICE_SERVICE_DISCOVERY_ADDRESS_LIST=rest-villains:8084 \
  -e QUARKUS_STORK_NARRATION_SERVICE_SERVICE_DISCOVERY_ADDRESS_LIST=rest-narration:8087 \
  -e QUARKUS_GRPC_CLIENTS_LOCATIONS_HOST=grpc-locations \
  -e QUARKUS_GRPC_CLIENTS_LOCATIONS_PORT=8089 \
  -e MP_MESSAGING_CONNECTOR_SMALLRYE_KAFKA_APICURIO_REGISTRY_URL=http://${DB_IP}:8086/apis/registry/v2 \
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

