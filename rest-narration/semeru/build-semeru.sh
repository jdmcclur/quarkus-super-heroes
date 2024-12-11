#!/bin/bash

podman build -f Dockerfile.semeru -t rest-narration:semeru-step1 ../
podman run --replace --name rest-narration-semeru-checkpoint-run --privileged --cpus 1 -m 1G --net myNetwork --net myNetwork --ip 192.168.200.23 -p 8087:8087 rest-narration:semeru-step1
podman commit rest-narration-semeru-checkpoint-run rest-narration:semeru
podman rm rest-narration-semeru-checkpoint-run

