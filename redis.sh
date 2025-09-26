#!/bin/bash

source ./common.sh
APP_NAME=redis
dnf module disable redis -y &>>$LOG_FILE
dnf module enable redis:7 -y &>>$LOG_FILE

dnf install redis -y &>>$LOG_FILE
VALIDATE $? "installed"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
VALIDATE $? "Allowing Remote connections to Redis"

systemctl enable redis &>>$LOG_FILE
VALIDATE $? "Enabling Redis"
systemctl start redis &>>$LOG_FILE
VALIDATE $? "Starting Redis"

print_total_time