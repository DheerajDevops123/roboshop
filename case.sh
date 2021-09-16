#!/bin/bash

UNAME=$(UNAME)

case $UNAME in
    LINUX)
    echo "linux"
        ;;
  WINDOWS)
  echo "windows"
  ;;
  *)
  echo "none"
esac