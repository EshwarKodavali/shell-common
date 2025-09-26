#!/bin/bash

source ./common.sh
APP_NAME=mysql
check_root
dnf install mysql-server -y &>>$LOG_FILE
VALIDATE $? "installing mysql"


systemctl enable mysqld
systemctl start mysqld &>>$LOG_FILE
VALIDATE $? "started mysql" 

mysql_secure_installation --set-root-pass RoboShop@1
VALIDATE $? "password set"
print_total_time