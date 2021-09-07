#!/bin/bash
source components/common.sh

print "Install NGINX\t\t"
yum install nginx -y &>>$LOG
STATUS $?

print "Download frontend HTML DOC"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
STATUS $?


print "Extracting FrontEnd\t"
rm -rf /usr/share/nginx/* && cd /usr/share/nginx && unzip -o /tmp/frontend.zip  &>>$LOG  &&  mv frontend-main/* .  &>>$LOG  &&  mv static html &>>$LOG
STATUS $?

print "Moving Roboshop Config\t"
mv localhost.conf /etc/nginx/default.d/roboshop.conf
STATUS $?

print "Update Roboshop Config\t"
sed -i -e "/catalogue/ s/localhost/catalogue.roboshop.internal/" /etc/nginx/default.d/roboshop.conf
STATUS $?

print "Restart NGINX\t\t"
systemctl restart nginx &>>$LOG
STATUS $?