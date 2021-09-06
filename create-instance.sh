#!/bin/bash

LID="lt-0c39b2152102f71c7"
LVER=1
INSTANCE_NAME=$1

if ( -z "{$INSTANCE_NAME}" ); then
echo "input is missing"
exit 1
fi

InstanceID=$(aws ec2 run-instances --launch-template LaunchTemplateId=$LID,Version=$LVER --tag-specifications 
ResourceType=spot-instances-request,Tags=[{Key=Name,Value=INSTANCE_NAME} 
ResourceType=instance,Tags=[{Key=Name,Value=INSTANCE_NAME} | 
jq .Instances[].InstanceId | sed -e 's/"//g')


