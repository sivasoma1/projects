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