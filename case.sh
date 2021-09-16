#!/bin/bash

UNAME=$(uname)

case $UNAME in
    LINUX)
    echo "linux"
    ;;
  WINDOWS)
  echo "windows"
  ;;
  *)
  echo "none"
  ;;
esac


# LOOPS 

for comp in frontend catalogue redis mongodb shipping payment ; do
    echo "setting up $comp"
    echo "Ended setting up $comp"
    done




