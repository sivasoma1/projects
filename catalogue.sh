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
validate $? "NodeJS Installation"

yum install nodejs -y &>>$log_file
validate $? "Install NodeJS"

useradd roboshop &>>$log_file
validate $? "user creating"

mkdir /app &>>$log_file
validate $? "create a file"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>>$log_file
validate $? "dowmloading the artifacts"

cd /app &>>$log_file
validate $? "moving to the  app directory"

unzip /tmp/catalogue.zip &>>$log_file
validate $? "unzipping the file"

cd /app &>>$log_file
validate $?

npm install &>>$log_file
validate $? "installing the packages"

cp /home/centos/projects/catalogue.service /etc/systemd/system/catalogue.service &>>$log_file
validate $? "coping"
systemctl daemon-reload &>>$log_file
validate $? " reloading"
systemctl enable catalogue &>>$log_file
validate $? "enabling"
systemctl start catalogue &>>$log_file
validate $? "starting"

cp /home/centos/projects/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
validate $?  "adding mongo repo"

yum install mongodb-org-shell -y &>>$log_file
validate $? "installing"

mongo --host mongodb.sssankar.site </app/schema/catalogue.js &>>$log_file
validate $? "connecting"