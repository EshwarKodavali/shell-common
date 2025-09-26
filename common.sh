#!/bin/bash

USER_ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
START_TIME=$(date +%s)
LOG_FOLDER="/var/log/shell-roboshop"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"
HOME_PATH=$PWD


mkdir -p $LOG_FOLDER

echo "Script started executed at: $(date)"
check_root(){
    if [ $USER_ID -ne 0 ]; then
        echo "please use root access"
        exit 1
    else
        echo "It is a root access"
    fi
}

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "$2 ... $R FAILURE $N"
    else
        echo -e "$2 ... $R SUCCESS $N"
    
    fi
}

nodejs_setup(){
    dnf module disable nodejs -y &>>$LOG_FILE
    VALIDATE $? "Disable nodejs"

    dnf module enable nodejs:20 -y &>>$LOG_FILE
    VALIDATE $? "enable nodejs"

    dnf install nodejs -y &>>$LOG_FILE
    VALIDATE $? "install nodejs"

    npm install &>>$LOG_FILE
    VALIDATE $? "installing NPM"
}

javasetup(){
    dnf install maven -y &>>$LOG_FILE
    VALIDATE $? "install maven"
    mvn clean package  &>>$LOG_FILE
    VALIDATE $? "package installing"
    mv target/shipping-1.0.jar shipping.jar
    VALIDATE $? "Renaming artifact"
}

app_setup(){
    id roboshop &>>$LOG_FILE
    if [ $? -ne 0 ]; then
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOG_FILE
        VALIDATE $? "User established"
    else
        echo -e "user already exists $Y SKIPPING $N"
    fi

    mkdir -p /app
    VALIDATE $? "created app folder"

    curl -o /tmp/$APP_NAME.zip https://roboshop-artifacts.s3.amazonaws.com/$APP_NAME-v3.zip &>>$LOG_FILE
    VALIDATE $? "Getting the URL"

    cd /app
    VALIDATE $? "Moving to directory"

    rm -rf /app/*
    VALIDATE $? "removing everthing in that directory"

    unzip /tmp/$APP_NAME.zip &>>$LOG_FILE
    VALIDATE $? "unzip $APP_NAME"
}

sytemd_steup(){
    cp $HOME_PATH/$APP_NAME.service /etc/systemd/system/$APP_NAME.service
    VALIDATE $? "created catlogue service"

    systemctl daemon-reload
    VALIDATE $? "daemon reloaded"

    systemctl enable $APP_NAME &>>$LOG_FILE
    VALIDATE $? "enable $APP_NAME"
}

restart_setup(){
    systemctl restart $APP_NAME
    VALIDATE $? "Restarted $APP_NAME"
}


print_total_time(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$(( $END_TIME - $START_TIME ))
    echo -e "Script executed in: $Y $TOTAL_TIME Seconds $N"
}