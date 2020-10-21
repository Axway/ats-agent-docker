#!/bin/bash

. ./env.sh

docker run --rm -it -p 8089:8089 --name agent \
  --mount type=bind,source=$(pwd)/../resources/add_actions,target=/opt/mount/ats \
  $IMAGE_NAME
