#!/bin/bash

STATUS() {
if [ $1 -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
else
    echo -e "\e[31mFAILURE\e[0m"
    echo -e "\e[33m Refer Log File : $LOG for more info\e[0m"
    exit 2
fi
}

print() {
    echo -e "\n\t\t\e[35m----------------$1----------------------\e[0m\n" >>$LOG
    echo -n -e "$1 \t- "
}

if [ $UID -ne 0 ]; then
echo -e "\e[1;33mYou Should execute this script as the root User\e[0m"
exit 1
fi

LOG=/tmp/roboshop.log
rm -f $LOG

ADD_APP_USER() {
    print "Adding Roboshop User\t"
    id roboshop &>>$LOG
    if [ $? -eq 0 ]; then
        echo "User already Exist" &>>$LOG
    else
        useradd roboshop &>>$LOG
    fi
    STATUS $?
}

DOWNLOAD() {
    print "Downloading $COMPONENT content"
    curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/roboshop-devops-project/$COMPONENT/archive/main.zip"
    STATUS $?
    
    print "Extracting $COMPONENT content"
    cd /home/roboshop
    rm -rf $COMPONENT && unzip -o /tmp/$COMPONENT.zip &>>$LOG && mv $COMPONENT-main $COMPONENT
    STATUS $?
}


SystemD_Setup() {
    print "Update SystemD Service\t"
    sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/' -e 's/CARTHOST/cart.roboshop.internal/' -e 's/USERHOST/user.roboshop.internal/' -e 's/AMQPHOST/rabbitmq.roboshop.internal/' /home/roboshop/$COMPONENT/systemd.service &>>$LOG
    STATUS $?
    
    print "Setup SystemD Service\t"
    mv /home/roboshop/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service && systemctl daemon-reload && systemctl restart $COMPONENT &>>$LOG && systemctl enable $COMPONENT &>>$LOG
    STATUS $?
}

NODEJS() {
    print "Installing the NodeJS\t"
    yum install nodejs make gcc-c++ -y &>>$LOG
    STATUS $?
    ADD_APP_USER
    DOWNLOAD
    print "Installing npm\t\t"
     cd /home/roboshop/$COMPONENT
    npm install --unsafe-perm &>>$LOG
    STATUS $?
    chown roboshop:roboshop -R /home/roboshop
    SystemD_Setup
}

JAVA() {
    print "Installing the Maven\t"
    yum install maven -y &>>$LOG
    STATUS $?
    ADD_APP_USER
    DOWNLOAD
    cd /home/roboshop/shipping
    print "Make Shipping Package\t"
    mvn clean package &>>$LOG
    STATUS $?
    print "Set Up Shipping Package"
    mv target/shipping-1.0.jar shipping.jar &>>$LOG
    STATUS $?
    chown roboshop:roboshop -R /home/roboshop
    SystemD_Setup
}

PYTHON() {
   print "Install Python\t\t"
    yum install python36 gcc python3-devel -y &>>$LOG
    STATUS $?
    ADD_APP_USER
    DOWNLOAD
    cd /home/roboshop/payment 
    print "Installing Dependencies"
    pip3 install -r requirements.txt &>>$LOG
    STATUS $?
    USERID=$(id -u roboshop)
    GROUPID=$(id -g roboshop)
    print "Update Roboshop User\t"
    sed -i -e "/uid/ c uid=$USERID " -e "/gid/ c gid=$GROUPID" /home/roboshop/payment/payment.ini &>>$LOG
    STATUS $?
   SystemD_Setup
}