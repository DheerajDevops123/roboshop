#!/bin/bash

source components/common.sh

print "Setup MySQL Repo\t"
echo '[mysql57-community]
name=MySQL 5.7 Community Server
baseurl=http://repo.mysql.com/yum/mysql-5.7-community/el/7/$basearch/
enabled=1
gpgcheck=0' > /etc/yum.repos.d/mysql.repo
STATUS $?

print "Install MySQL\t\t\t"
yum remove mariadb-libs -y &>>$LOG && yum install mysql-community-server -y &>>$LOG
STATUS $?

print "Start MySQL\t\t\t"
systemctl enable mysqld &>>$LOG && systemctl start mysqld &>>$LOG
STATUS $?

PASSWORD=$(grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')

print "Reset Default Password\t\t"
echo 'show databases' | mysql -uroot -pRoboShop@1 &>>$LOG
if [ $? -eq 0 ]; then
    echo "Root Password is already set" &>>$LOG
else
    echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1';" >/tmp/reset.sql
    mysql --connect-expired-password -u root -p"${PASSWORD}" </tmp/reset.sql
fi
STATUS $?

print "Uninstall Password validate plugin"
echo 'show plugins;' | mysql -u root -p"RoboShop@1" 2>/dev/null | grep -i validate_password &>>$LOG
if [ $? -eq 0 ]; then
    echo "uninstall plugin validate_password;" >/tmp/pass.sql
    mysql -u root -p"RoboShop@1" </tmp/pass.sql &>>$LOG
else
    echo "Validate Password Plugin is already uninstalled" &>>$LOG
fi
STATUS $?


print "Downloading Schema\t\t"
curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip" &>>$LOG
STATUS $?

print "Extract Schema\t\t\t"
cd /tmp && unzip -o mysql.zip &>>$LOG
STATUS $?

print "Loading Schema\t\t\t"
cd mysql-main
mysql -u root -pRoboShop@1 <shipping.sql &>>$LOG
STATUS $?