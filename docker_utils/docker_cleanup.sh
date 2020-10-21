#!/bin/bash

. ./env.sh
# Delete all containers
docker rm $(docker ps -a -q)

# Delete all images
#docker rmi $(docker images -q)

# OR Delete all images, containers and cached entries
# for volumes you should add additional parameter
#docker system prune
