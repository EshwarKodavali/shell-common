#!/bin/bash

source ./common.sh
APP_NAME=shipping

check_root
app_setup
javasetup
sytemd_steup
dnf install mysql -y &>>$LOG_FILE
VALIDATE $? "install mysql"

mysql -h mysql.eshwar.fun -uroot -pRoboShop@1 -e 'cities' &>>$LOG_FILE
if [ $? -ne 0 ]; then
    mysql -h mysql.eshwar.fun -uroot -pRoboShop@1 < /app/db/schema.sql &>>$LOG_FILE
    mysql -h mysql.eshwar.fun -uroot -pRoboShop@1 < /app/db/app-user.sql  &>>$LOG_FILE
    mysql -h mysql.eshwar.fun -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$LOG_FILE
else
    echo -e "Shipping data is already loaded ... $Y SKIPPING $N"
fi
restart_setup
print_total_time
