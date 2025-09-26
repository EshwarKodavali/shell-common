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

print_total_time(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$(( $END_TIME - $START_TIME ))
    echo -e "Script executed in: $Y $TOTAL_TIME Seconds $N"
}