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

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$log_file
validate $? "Installing NodeJS via Nodesource"

yum install nodejs -y &>>$log_file
validate $? "installing nodeJs

useradd roboshop &>>$log_file
validate $? "Creating User roboshop"

mkdir /app &>> $log_file

validate $? "Creating App Directory"


cd /app &>>$log_file

validate $? "change directory"

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>>$log_file

validate $? "Downloading RoboShop User Build"

cd /app 

validate $? "Change to app dir and unpack the zip file"

unzip -q /tmp/user.zip &>>$log_file
validate $? "unzipping"

cd /app 
validate $? "changing  back to app folder"

npm install &>>$log_file
validate $? "Running npm install in app folder"

cp /home/centos/projects/user.service  /etc/systemd/system/user.service &>>$log_file
validate $? "Copy user service to systemd location"

systemctl daemon-reload &>>$log_file
validate $? "reload"

systemctl enable user &>>$log_file
validate $? "enable"

systemctl start user &>>$log_file
validate  $? "Starting user service"

cp /home/centos/projects/mongo.repo /etc/yum.repos.d/mongo.repo
validate $? "coping"

yum install mongodb-org-shell -y &>>$log_file
validate $? "Install MongoDB shell"

mongo --host mongodb.sssankar.site </app/schema/user.js &>>$log_file
validate $? "Creating DB and Collections using mongo script"