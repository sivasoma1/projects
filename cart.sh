#!/bin/bash

# our program goal is to install mysql

DATE=$(date +%F:%H:%M:%S)
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


curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOGFILE

VALIDATE $?  "Installing NodeJS via Nodesource"

yum install nodejs -y &>>$LOGFILE

VALIDATE  $?  "Installing NodeJS from YUM repository"

id roboshop &>>$LOGFILE
if [ $? -eq 0 ];
    then 
        VALIDATE $? "file is already exists"
    
    else 
        useradd roboshop &>>$LOGFILE
fi

VALIDATE $? "adding roboshop user"

if [ $? -eq 0 ];
    then
        VALIDATE $? "/app is already exists"
        exit 1
    else 
        mkdir /app &>>$LOGFILE
        VALIDATE $? "creating app directory"
fi



curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>>$LOGFILE
VALIDATE $? "Downloading cart source code"

cd /app &>>$LOGFILE
VALIDATE $? "moving"


unzip -o /tmp/cart.zip &>>$LOGFILE

VALIDATE $? "unzipping cart"




npm install &>>$LOGFILE
VALIDATE $? "Running npm install in the app folder"

cp /home/centos/projects/cart.service /etc/systemd/system/cart.service &>>LOGFILE
VALIDATE $? "moving"


systemctl daemon-reload &>>$logfile
VALIDATE $? "reloading"

systemctl enable cart &>>$logfile
VALIDATE $? "enabling"

systemctl start cart &>>$logfile
VALIDATE $? "starting"
