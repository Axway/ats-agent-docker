#!/bin/bash

. ./env.sh
#docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"
VERSION=latest
REGISTRY="" # DockerHub
REGISTRY="10.11.12.13:5000/" # Some local registry

docker tag ats-agent ${REGISTRY}axway/$IMAGE_NAME:$VERSION

docker push ${REGISTRY}axway/$IMAGE_NAME:$VERSION
