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
    if [ $1 -ne 0 ];
    then
        echo -e "$2 ... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

USERID=$(id -u)

if [ $USERID -ne 0 ];
then
    echo "ERROR:: Please run this script with root access"
    exit 1
# else
#     echo "INFO:: You are root user"
fi


curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOGFILE
validate $? "NodeJS Installation"

yum install nodejs -y &>>$LOGFILE
validate $? "Install NodeJS"

useradd roboshop &>>$LOGFILE
validate $? "user creating"

mkdir /app &>>$LOGFILE
validate $? "create a file"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>>$LOGFILE
validate $? "dowmloading the artifacts"

cd /app &>>$LOGFILE
validate $? "moving to the  app directory"

unzip /tmp/catalogue.zip &>>$LOGFILE
validate $? "unzipping the file"

cd /app &>>$LOGFILE
validate $?

npm install &>>$LOGFILE
validate $? "installing the packages"

cp /home/centos/projects/catalogue.service /etc/systemd/system/catalogue.service &>>$LOGFILE
validate $? "coping"
systemctl daemon-reload &>>$LOGFILE
validate $? " reloading"
systemctl enable catalogue &>>$LOGFILE
validate $? "enabling"
systemctl start catalogue &>>$LOGFILE
validate $? "starting"

cp /home/centos/projects/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE
validate $?  "adding mongo repo"

yum install mongodb-org-shell -y &>>$LOGFILE
validate $? "installing"

mongo --host mongodb.sssankar.site </app/schema/catalogue.js &>>$LOGFILE
validate $? "connecting"