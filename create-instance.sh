#!/bin/bash

LID="lt-0c39b2152102f71c7"
LVER=1
INSTANCE_NAME=$1

if [ -z "${INSTANCE_NAME}" ]; then
echo "input is missing"
exit 1
fi

aws ec2 describe-instances --filters "Name=tag:Name,Values=$INSTANCE_NAME" | jq .Reservations[].Instances[].State.Name | grep running &>>/dev/null
if [ $? -eq 0]; then
echo "Instance $INSTANCE_NAME is already running"
exit 0
else
IP=$(aws ec2 run-instances --launch-template LaunchTemplateId=$LID,Version=$LVER --tag-specifications "ResourceType=spot-instances-request,Tags=[{Key=Name,Value=$INSTANCE_NAME}]" "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME}]" | jq .Instances[].PrivateIpAddress | sed -e 's/"//g')
fi

