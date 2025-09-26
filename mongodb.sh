#!/bin/bash/

source ./common.sh

check_root

cp mongodb.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "imported to repo"

dnf install mongodb-org -y &>>$LOG_FILE
VALIDATE $? "installed mongodb"

systemctl enable mongod &>>$LOG_FILE
VALIDATE $? "enabled mongodb"

systemctl start mongod
VALIDATE $? "started mongodb" 

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "Allowing remote connections to MongoDB"

systemctl restart mongod
VALIDATE $? "Restarted mongodb"

print_total_time

