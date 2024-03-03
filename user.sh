#!/bin/bash

# our program goal is to install mysql

DATE=$(date +%F:%H:%M:%S)
SCRIPT_NAME=$0
LOGFILE=/tmp/$SCRIPT_NAME-$DATE.log

R="\e[31m"
G="\e[32m"
N="\e[0m"

# this function should VALIDATE the previous command and inform user it is success or failure
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
VALIDATE $? "Installing NodeJS via Nodesource"

yum install nodejs -y &>>$LOGFILE
VALIDATE $? "installing nodeJs"

id roboshop &>>$LOGFILE
if [ $? -eq 0 ];
    then 
        VALIDATE $? "file is already exists"
    
    else 
        useradd roboshop &>>$LOGFILE
fi

VALIDATE $? "adding roboshop user"

if [ $? -eq 0 ];
    then
        VALIDATE $? "/app is already exists"
    else 
        mkdir -p /app &>>$LOGFILE
        VALIDATE $? "creating app directory"
fi

cd /app &>>$LOGFILE

VALIDATE $? "change directory"

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>>$LOGFILE

VALIDATE $? "Downloading RoboShop User Build"

cd /app 

VALIDATE $? "Change to app dir and unpack the zip file"

unzip -o /tmp/user.zip &>>$LOGFILE
VALIDATE $? "unzipping"

cd /app 
VALIDATE $? "changing  back to app folder"

npm install &>>$LOGFILE
VALIDATE $? "Running npm install in app folder"

cp /home/centos/projects/user.service  /etc/systemd/system/user.service &>>$LOGFILE
VALIDATE $? "Copy user service to systemd location"

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "reload"

systemctl enable user &>>$LOGFILE
VALIDATE $? "enable"

systemctl start user &>>$LOGFILE
VALIDATE  $? "Starting user service"

cp /home/centos/projects/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "coping"

yum install mongodb-org-shell -y &>>$LOGFILE
VALIDATE $? "Install MongoDB shell"

mongo --host mongodb.sssankar.site </app/schema/user.js &>>$LOGFILE
VALIDATE $? "Creating DB and Collections using mongo script" 