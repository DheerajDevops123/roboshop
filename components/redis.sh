#!/bin/bash
source components/common.sh

print "Install Yum Utils & Download Redis Repo"
yum install epel-release yum-utils -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y &>>$LOG
STATUS $?

print "Set Up Redis Repo"
yum-config-manager --enable remi &>>$LOG
STATUS $?

print "Install Redis"
yum install redis -y &>>$LOG
STATUS $?

print "Configuring Redis"
sed -i -e "s/127.0.0.1/0.0.0.0" /etc/redis.conf
STATUS $?

print "Start Redis Database"
systemctl enable redis && systemctl restart redis &>>$LOG
STATUS $?
