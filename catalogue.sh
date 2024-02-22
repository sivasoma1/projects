#!/bin/bash

log_dir=/tmp
Date=$(date +%F:H:M:S)
filename=$0
log_file=$log_dir/$filename-$Date.log
userid =$(id -u)

$R= "\e[31m"

$G= "\e[32m"

$Y= "\e[33m"

$N= "\e[0m"



if [ $userid -ne 0 ];
    then
        echo "Error: $R Root user $N"
        exit 1
fi
validate() {

    if [ $1 -ne 0 ];
        then 
            echo "$1 $R Failure $N"
            exit 1
        else
            echo "$1 $G Success $N"
    fi
}

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