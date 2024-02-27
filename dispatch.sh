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

yum install golang -y &>>$LOGFILE

VALIDATE $? "installing golang "

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
    else 
        mkdir -p /app &>>$LOGFILE
        VALIDATE $? "creating app directory"
fi

curl -L -o /tmp/dispatch.zip https://roboshop-builds.s3.amazonaws.com/dispatch.zip &>>$LOGFILE
VALIDATE $? "downloading dispatch"

cd /app &>>$LOGFILE 
VALIDATE $? "creating a directory"

unzip -o /tmp/dispatch.zip &>>$LOGFILE

VALIDATE $? "extracting the zip file"

cd /app &>>$LOGFILE
VALIDATE $? "re switching to that directory"

go mod init dispatch &>>$LOGFILE
validae $? "init"

go get &>>$LOGFILE

VALIDATE $? "get"

go build &>>$LOGFILE

VALIDATE $? "building the application"

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "To load the service"

systemctl enable dispatch &>>$LOGFILE

VALIDATE $?  "Enable the service at startup" 

systemctl start dispatch &>>$LOGFILE

VALIDATE  $? "Starting the service"

cp /home/centos/projects/dispatch.service /etc/systemd/system/dispatch.service &>>$LOGFILE

VALIDATE $? "coping"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "loading"

systemctl enable dispatch &>>$LOGFILE 

VALIDATE $? "enbale"

systemctl start dispatch &>>$LOGFILE
VALIDATE $? "starting"

