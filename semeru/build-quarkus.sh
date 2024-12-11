#!/bin/bash

cd ../grpc-locations
./mvnw -f pom.xml clean package -Dmaven.test.skip

cd ../rest-fights
./mvnw -f pom.xml clean package -Dmaven.test.skip

cd ../rest-heroes
./mvnw -f pom.xml clean package -Dmaven.test.skip

cd ../rest-narration
./mvnw -f pom.xml clean package -Dmaven.test.skip

cd ../rest-villains
./mvnw -f pom.xml clean package -Dmaven.test.skip



