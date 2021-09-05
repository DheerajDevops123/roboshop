#!/bin/bash
source components/common.sh

print "Setting up MongoDB Repository"
echo '[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc' >/etc/yum.repos.d/mongodb.repo
STATUS $?

print "Installing MongoDB\t"
yum install -y mongodb-org &>>$LOG
STATUS $?

print "Configuring MongoDB\t"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
STATUS $?

print "Starting MongoDB\t"
systemctl enable mongod
systemctl restart mongod
STATUS $?

print "Downloading MongoDB Schema"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"
STATUS $?

cd /tmp
print "Extracting Schema\t"
unzip -o mongodb.zip &>>$LOG
STATUS $?

cd mongodb-main
print "Loading Schema\t\t"
mongo < catalogue.js &>>$LOG
mongo < users.js &>>$LOG
STATUS $?
