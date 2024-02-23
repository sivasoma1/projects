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

yum install python36 gcc python3-devel -y &>>$log_file
validate $? "installing python"

useradd roboshop &>>$log_file
validate $? "useradd"

mkdir /app &>>$log_file

validate $? "creating an app directory"

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>>$log_file

validate $? "downloading payment module"

cd /app &>>$log_file
validate $? "changing to the app dir"

unzip /tmp/payment.zip &>>$log_file
validate $? "unzipping"

cd /app &>>$log_file
validate $? "changing  back to the app dir"


pip3.6 install -r requirements.txt &>>$log_file

validate $? "Installing Python dependencies with pip"

cp /home/centos/projects/payment.service /etc/systemd/system/payment.service &>>$log_file
validate $? "coping"

systemctl daemon-reload &>>$log_file
validate $? "daemon"

systemctl enable payment &>>$log_file
validate $? "enable"

systemctl start payment &>>$log_file

validate $? "starting"
