#!/bin/bash

DATE=$(date +%F)
LOGSDIR=/home/centos/shellscript-logs
# /home/centos/shellscript-logs/script-name-date.log
SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$0-$DATE.log
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

if [ $USERID -ne 0 ];
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ];
    then
        echo -e "Installing $2 ... $R FAILURE $N"
        exit 1
    else
        echo -e "Installing $2 ... $G SUCCESS $N"
    fi
}




curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOGFILE
VALIDATE $? "NodeJS Installation"

yum install nodejs -y &>>$LOGFILE
VALIDATE $? "Install NodeJS"

id roboshop &>>$LOGFILE
if [ $? -eq 0 ];
then
    VALIDATE $? "user exists"
else
    useradd roboshop &>>$LOGFILE
    VALIDATE $? "user creating"
fi


mkdir -p /app &>>$LOGFILE
VALIDATE $? "create a file"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>>$LOGFILE
VALIDATE $? "dowmloading the artifacts"

cd /app &>>$LOGFILE
VALIDATE $? "moving to the  app directory"

unzip /tmp/catalogue.zip &>>$LOGFILE
VALIDATE $? "unzipping the file"

cd /app &>>$LOGFILE
VALIDATE $?

npm install &>>$LOGFILE
VALIDATE $? "installing the packages"

cp /home/centos/projects/catalogue.service /etc/systemd/system/catalogue.service &>>$LOGFILE
VALIDATE $? "coping"

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? " reloading"

systemctl enable catalogue &>>$LOGFILE
VALIDATE $? "enabling"

systemctl start catalogue &>>$LOGFILE
VALIDATE $? "starting"

cp /home/centos/projects/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE
VALIDATE $?  "adding mongo repo"

yum install mongodb-org-shell -y &>>$LOGFILE
VALIDATE $? "installing"

mongo --host mongodb.sssankar.site </app/schema/catalogue.js &>>$LOGFILE
VALIDATE $? "connecting"