#!/bin/bash

source ./common.sh
APP_NAME=catalogue
check_root
app_setup
nodejs_setup
sytemd_steup


cp $HOME_PATH/mongodb.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "created mongo repo"

dnf install mongodb-mongosh -y &>>$LOG_FILE
VALIDATE $? "intalled mongodb"

INDEX=$(mongosh mongodb.eshwar.fun --quiet --eval "db.getMongo().getDBNames().indexOf('catalogue')")
if [ $INDEX -le 0 ]; then
    mongosh --host mongodb.eshwar.fun </app/db/master-data.js &>>$LOG_FILE
    VALIDATE $? "Load $APP_NAME products"
else
    echo -e "$APP_NAME products already loaded ... $Y SKIPPING $N"
fi

restart_setup
print_total_time