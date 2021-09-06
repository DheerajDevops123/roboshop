#!/bin/bash

LID="lt-0c39b2152102f71c7"
LVER=2

aws ec2 run-instances --launch-template LaunchTemplateId=$LID,Version=$LVER
