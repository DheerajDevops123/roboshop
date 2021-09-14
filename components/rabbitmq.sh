#!/bin/bash
source components/common.sh

print "Installing Erlang\t\t"
yum list installed | grep erlang &>>$LOG
if [ $? -eq 0 ]; then
    echo "Already Installed Erlang\t" &>>$LOG
else
    yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y &>>$LOG
fi
STATUS $?

print "Setup YUM repositories for RabbitMQ"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>$LOG
STATUS $?

print "Install RabbitMQ\t\t"
yum install rabbitmq-server -y &>>$LOG
STATUS $?

print "Start RabbitMQ\t\t\t"
systemctl enable rabbitmq-server &>>$LOG && systemctl start rabbitmq-server &>>$LOG
STATUS $?

print "Create application user\t\t"
rabbitmqctl list_users | grep roboshop &>>$LOG
if [ $? -ne 0 ]; then
rabbitmqctl add_user roboshop roboshop123 &>>$LOG 
fi
rabbitmqctl set_user_tags roboshop administrator &>>$LOG && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOG
STATUS $?