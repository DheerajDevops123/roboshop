#!/bin/bash
source components/common.sh

print "Install NGINX"
yum install nginx -y &>>$LOG
STATUS $?

print "Download frontend HTML Doc"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$LOG
STATUS $?


print "Extracting FrontEnd"
rm -rf usr/share/nginx/html && cd /usr/share/nginx/html && unzip -o /tmp/frontend.zip && mv frontend-main/* . && mv static/* . &>>$LOG
STATUS $?

print "Update Roboshop Config"
mv localhost.conf /etc/nginx/default.d/roboshop.conf
STATUS $?

print "Restart NGINX"
systemctl restart nginx &>>$LOG
STATUS $?