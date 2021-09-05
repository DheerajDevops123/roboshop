#!/bin/bash

read -p "Enter the input: " input
if [ -z "$input" ];
then
echo "input is empty"
exit 1
fi
if [ "$input" == "ABC" ];
then
echo "input is ABC"
fi
echo "input" = $input
if [ $? -eq 0 ];
then
echo sucess
else
echo failure
fi
