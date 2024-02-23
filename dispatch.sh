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

yum install golang -y &>>$LOGFILE

validate $? "installing golang "

useradd roboshop &>>$LOGFILE

validate $? "creating an user"

mkdir /app &>>$LOGFILE
validate $? "creating a directory"

curl -L -o /tmp/dispatch.zip https://roboshop-builds.s3.amazonaws.com/dispatch.zip &>>$LOGFILE
validate $? "downloading dispatch"

cd /app &>>$LOGFILE 
validate $? "creating a directory"

unzip /tmp/dispatch.zip &>>$LOGFILE

validate $? "extracting the zip file"

cd /app &>>$LOGFILE
validate $? "re switching to that directory"

go mod init dispatch &>>$LOGFILE
validae $? "init"

go get &>>$LOGFILE

validate $? "get"

go build &>>$LOGFILE

validate $? "building the application"

systemctl daemon-reload &>>$LOGFILE
validate $? "To load the service"

systemctl enable dispatch &>>$LOGFILE

validate $?  "Enable the service at startup" 

systemctl start dispatch &>>$LOGFILE

validate  $? "Starting the service"

cp /home/centos/projects/dispatch.service /etc/systemd/system/dispatch.service &>>$LOGFILE

validate $? "coping"

systemctl daemon-reload &>>$LOGFILE

validate $? "loading"

systemctl enable dispatch &>>$LOGFILE 

validate $? "enbale"

systemctl start dispatch &>>$LOGFILE
validate $? "starting"

