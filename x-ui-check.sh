#!/bin/bash

if systemctl --quiet is-active x-ui
then
  echo "x-ui is running"
else
  echo "x-ui is not running, restarting..."
  systemctl start x-ui
fi
