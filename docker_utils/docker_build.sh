#!/bin/bash

. ./env.sh

docker build -t $IMAGE_NAME $DOCKERFILE_LOCATION
