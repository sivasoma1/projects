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

