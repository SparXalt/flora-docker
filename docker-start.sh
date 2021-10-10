#!/usr/bin/env bash

# shellcheck disable=SC2154
if [[ ${farmer} == 'true' ]]; then
  flora start farmer-only
elif [[ ${harvester} == 'true' ]]; then
  if [[ -z ${farmer_address} || -z ${farmer_port} || -z ${ca} ]]; then
    echo "A farmer peer address, port, and ca path are required."
    exit
  else
    flora configure --set-farmer-peer "${farmer_address}:${farmer_port}"
    flora start harvester
  fi
else
  flora start farmer
fi

trap "flora stop all -d; exit 0" SIGINT SIGTERM

# Ensures the log file actually exists, so we can tail successfully
touch "$FLORA_ROOT/log/debug.log"
tail -f "$FLORA_ROOT/log/debug.log" &
while true; do sleep 1; done
