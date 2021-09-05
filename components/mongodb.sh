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

print "Setting up MongoDB Repository"
echo '[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc' >/etc/yum.repos.d/mongodb.repo
STATUS $?

print "\tInstalling MongoDB"
yum install -y mongodb-org &>>/tmp/log
STATUS $?

print "\tConfiguring MongoDB"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
STATUS $?

print "\tStarting MongoDB"
systemctl enable mongod
systemctl restart mongod
STATUS $?

print "Downloading MongoDB Schema"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"
STATUS $?

cd /tmp
print "\tExtracting Schema"
unzip -o mongodb.zip &>>/tmp/log
STATUS $?

cd mongodb-main
print "\t\tLoading Schema"
mongo < catalogue.js &>>/tmp/log
mongo < users.js &>>/tmp/log
STATUS $?
