#!/bin/bash

STATUS() {
if [ $1 -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
else
    echo -e "\e[31mFAILURE\e[0m"
    exit 2
fi
}

print() {
    echo -n -e "$1 \t- "
}

if [ $UID -ne 0 ]; then
echo -e "\e[1;33mYou Should execute this script as the root User\e[0m"
exit 1
fi

LOG=/tmp/roboshop.log
rm -f $LOG