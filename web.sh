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
yum install nginx -y &>>$log_file

validate $? "Installing Nginx package"

systemctl enable nginx &>>$log_file

validate $? "enabling the nginx"

systemctl start nginx &>>$log_file

validate $? "starting nginx"



rm -rf /usr/share/nginx/html/* &>>$log_file
validate $? "removing the default html files"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>>$log_file

validate $? " downloading web artifact"

cd /usr/share/nginx/html &>>$log_file

validate $? "moving to default htmldirectory"

unzip /tmp/web.zip &>>$log_file

validate $? "unzipping"

cp /home/centos/projects/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$log_file
validate $? "coping roboshop.config"


systemctl restart nginx &>> $log_file

$validate $? "restarting"