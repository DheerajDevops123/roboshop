#!/bin/bash

source components/common.sh

print "Installing the NodeJS"
yum install nodejs make gcc-c++ -y &>>$LOG
STATUS $?

print "Adding Roboshop User"
id roboshop &>>$LOG
if [ $? -eq 0 ]; then
    echo "User already Exist" &>>$LOG
else
    useradd roboshop &>>$LOG
fi
STATUS $?

print "Downloading Catalogue"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip"
STATUS $?

print "Extracting Catalogue"
cd /home/roboshop
rm -rf catalogue && unzip -o /tmp/catalogue.zip &>>$LOG && mv catalogue-main catalogue
STATUS $?

cd /home/roboshop/catalogue

print "Installing npm\t"
npm install --unsafe-perm &>>$LOG
STATUS $?

chown roboshop:roboshop -R /home/roboshop

print "Update SystemD Service"
sed -i -e "s/MONGO_DNSNAME/mongodb.roboshop.internal/" /home/roboshop/catalogue/systemd.service &>>$LOG
STATUS $?

print "Setup SystemD Service"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service && systemctl daemon-reload && systemctl restart catalogue &>>$LOG && systemctl enable catalogue &>>$LOG
STATUS $?