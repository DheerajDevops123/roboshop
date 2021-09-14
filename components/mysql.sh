#!/bin/bash

source components/common.sh

print "Setup MySQL Repo"
echo '[mysql57-community]
name=MySQL 5.7 Community Server
baseurl=http://repo.mysql.com/yum/mysql-5.7-community/el/7/$basearch/
enabled=1
gpgcheck=0' > /etc/yum.repos.d/mysql.repo
STATUS $?

print "Install MySQL\t"
yum remove mariadb-libs -y &>>$LOG && yum install mysql-community-server -y &>>$LOG
STATUS $?

print "Start MySQL\t"
systemctl enable mysqld &>>$LOG && systemctl start mysqld &>>$LOG
STATUS $?

PASSWORD=$(grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')

print "Reset Default Password"
echo 'show databases' | mysql -uroot -pRoboShop@1 &>>$LOG
if [ $? -eq 0 ]; then
    echo "Root Password is already set" &>>$LOG
else
    echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1';" >/tmp/reset.sql
    mysql --connect-expired-password -u root -p"${PASSWORD}" </tmp/reset.sql
fi
STATUS $?

print "Uninstall Password validate plugin"
echo "uninstall plugin validate_password;" >/tmp/pass.sql
mysql -u root -p"RoboShop@1" </tmp/pass.sql
STATUS $?


print "Downloading Schema"
curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip" &>>$LOG
STATUS $?

print "Extract Schema"
cd /tmp && unzip -o mysql.zip &>>$LOG

print "Loading Schema"
cd mysql-main
mysql -u root -pRoboShop@1 <shipping.sql &>>$LOG
STATUS $?