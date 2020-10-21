#!/bin/bash

. ./env.sh

docker run -td -p 8089:8089 $IMAGE_NAME
