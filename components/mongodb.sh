echo "Setting up MongoDB Repository"

echo '[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc' >/etc/yum.repos.d/mongodb.repo
STATUS

echo "Installing MongoDB"
yum install -y mongodb-org &>>/tmp/log
STATUS

echo "Configuring MongoDB"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
STATUS

echo "Starting MongoDB"
systemctl enable mongod
systemctl restart mongod
STATUS

echo "Downloading MongoDB Schema"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"
STATUS

cd /tmp
echo "Extracting Schema"
unzip -o mongodb.zip &>>/tmp/log
STATUS

cd mongodb-main
echo "Loading Schema"
mongo < catalogue.js &>>/tmp/log
mongo < users.js &>>/tmp/log
STATUS
