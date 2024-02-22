#!/bin/bash

log_dir=/tmp
Date=$(date +%F:H:M:S)
filename=$0
log_file=$log_dir/$filename-$Date.log
userid = $(id -u)

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

validate $?  "Installing NodeJS via Nodesource"

yum install nodejs -y &>>$log_file

validate  $?  "Installing NodeJS from YUM repository"

useradd roboshop &>>$log_file

validate $? "adding roboshop user"

mkdir /app &>>$log_file


validate $? "creating app directory"

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>>$log_file
validate $? "Downloading cart source code"

cd /app  &>>$log_file
validate $? "moving"

npm install &>>$log_file
validate $? "Running npm install in the app folder"

cp /home/centos/projects/cart.service /etc/systemd/system/cart.service &>>log_file
validate $? "moving"


systemctl daemon-reload &>>$logfile
validate $? "reloading"

systemctl enable cart &>>$logfile
validate $? "enabling"

systemctl start cart &>>$logfile
validate $? "starting"
