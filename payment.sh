#!/bin/bash

# our program goal is to install mysql

DATE=$(date +%F)
SCRIPT_NAME=$0
LOGFILE=/tmp/$SCRIPT_NAME-$DATE.log

R="\e[31m"
G="\e[32m"
N="\e[0m"

# this function should VALIDATE the previous command and inform user it is success or failure
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

yum install python36 gcc python3-devel -y &>>$LOGFILE
VALIDATE $? "installing python"

useradd roboshop &>>$LOGFILE
VALIDATE $? "useradd"

mkdir /app &>>$LOGFILE

VALIDATE $? "creating an app directory"

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>>$LOGFILE

VALIDATE $? "downloading payment module"

cd /app &>>$LOGFILE
VALIDATE $? "changing to the app dir"

unzip /tmp/payment.zip &>>$LOGFILE
VALIDATE $? "unzipping"

cd /app &>>$LOGFILE
VALIDATE $? "changing  back to the app dir"


pip3.6 install -r requirements.txt &>>$LOGFILE

VALIDATE $? "Installing Python dependencies with pip"

cp /home/centos/projects/payment.service /etc/systemd/system/payment.service &>>$LOGFILE
VALIDATE $? "coping"

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "daemon"

systemctl enable payment &>>$LOGFILE
VALIDATE $? "enable"

systemctl start payment &>>$LOGFILE

VALIDATE $? "starting"
