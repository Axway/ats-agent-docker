#!/bin/bash

. ./env.sh

HAS_CONTAINER=`docker container ps | grep $IMAGE_NAME | wc -l`

if [ "$HAS_CONTAINER" -eq 1 ];
then
    CONTAINER_ID=`docker container ps | grep $IMAGE_NAME | awk '{n=split($0,a," "); print a[1]}'`
    docker container stop $CONTAINER_ID
else
    echo "Container $IMAGE_NAME is not running."
fi

