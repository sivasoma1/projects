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

yum install maven -y &>>$log_file

validate $? "installing"

useradd roboshop &>>$log_file
validate $? "creating user"

mkdir /app &>>$log_file
validate $? "creating app directory"

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip  &>>$log_file
validate $? "downloading shipping module"
cd /app &>>$log_file
validate $? "change directory"

unzip /tmp/shipping.zip -d /app &>>$log_file
validate $? "extracting shipping package"

cd /app &>>$log_file
validate $? "change directory to app directory"

mvn clean package &>>$log_file

mv target/shipping-1.0.jar shipping.jar


cp /home/centos/projects/shipping.service /etc/systemd/system/shipping.service &>>$log_file
validate $? "copy service file"

systemctl daemon-reload &>>$log_file
validate $? "deamon"

systemctl enable shipping &>>$log_file
validate $? "enable"

systemctl start shipping &>>$log_file
validate $? "starting"

