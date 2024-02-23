#!/bin/bash

# our program goal is to install mysql

DATE=$(date +%F)
SCRIPT_NAME=$0
LOGFILE=/tmp/$SCRIPT_NAME-$DATE.log

R="\e[31m"
G="\e[32m"
N="\e[0m"

# this function should validate the previous command and inform user it is success or failure
VALIDATE(){
    #$1 --> it will receive the argument1
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

USERID=$(id -u)

if [ $USERID -ne 0 ]
then
    echo "ERROR:: Please run this script with root access"
    exit 1
# else
#     echo "INFO:: You are root user"
fi


curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOGFILE

validate $?  "Installing NodeJS via Nodesource"

yum install nodejs -y &>>$LOGFILE

validate  $?  "Installing NodeJS from YUM repository"

useradd roboshop &>>$LOGFILE

validate $? "adding roboshop user"

mkdir /app &>>$LOGFILE


validate $? "creating app directory"

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>>$LOGFILE
validate $? "Downloading cart source code"

cd /app  &>>$LOGFILE
validate $? "moving"

npm install &>>$LOGFILE
validate $? "Running npm install in the app folder"

cp /home/centos/projects/cart.service /etc/systemd/system/cart.service &>>LOGFILE
validate $? "moving"


systemctl daemon-reload &>>$logfile
validate $? "reloading"

systemctl enable cart &>>$logfile
validate $? "enabling"

systemctl start cart &>>$logfile
validate $? "starting"
