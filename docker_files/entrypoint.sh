#!/usr/bin/env bash

# script debug mode
# set -x
MOUNT=/opt/mount/ats
ATS_AGENT=/home/atsuser/ats-agent
echo "Start of entrypoint"

echo "Checking for additional ATS actions components mounted at $MOUNT"
echo "Listing \"${MOUNT}/actions\" actions dir: $(ls -la ${MOUNT}/actions)"
if [[ -d ${MOUNT}/actions/ ]]; then
  echo "Found custom actions to be copied: $(ls $MOUNT/actions/)"
  cp ${MOUNT}/actions/* ${ATS_AGENT}/actions/

  if [[ -d ${MOUNT}/actions_dependencies/ ]]; then
     echo "Found custom actions dependencies to be copied: $(ls -R ${MOUNT}/actions_dependencies/)"
     cp -R ${MOUNT}/actions_dependencies/* ${ATS_AGENT}/actions_dependencies/
  fi
  chown -R $USERNAME:0 ${ATS_AGENT}/actions/ ${ATS_AGENT}/actions_dependencies/
else
  echo "Not found folder with additional actions in ${MOUNT}/actions/"
fi

echo "Listing of agent folder "
ls -lRa

if [[ -f ./agent.sh ]]; then
    echo "Starting Agent with parameters: container $@"
    ./agent.sh container "$@"
else
    echo "Not found agent.sh script in directory $(pwd)"
    exit 1;
fi

