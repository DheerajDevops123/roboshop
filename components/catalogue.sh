source components/common.sh

print "Installing the NodeJS"
yum install nodejs make gcc-c++ -y
STATUS $?

print "Adding Roboshop User"
useradd roboshop &>>$LOG
STATUS $?

print "Downloading Catalogue"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip"
STATUS $?

print "Extracting Catalogue"
cd /home/roboshop
unzip -o /tmp/catalogue.zip &>>$LOG
mv catalogue-main catalogue
STATUS $?

cd /home/roboshop/catalogue

print "Installing npm"
npm install 
STATUS $?

# NOTE: We need to update the IP address of MONGODB Server in systemd.service file
# Now, lets set up the service with systemctl.

mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
systemctl daemon-reload
systemctl start catalogue
systemctl enable catalogue