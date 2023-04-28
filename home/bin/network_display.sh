#!/bin/bash


sleep 2
myssid=$(iwgetid -r)

if [ $myssid == "SPACES" ]; then
  ~/.screenlayout/spaces.sh
fi

