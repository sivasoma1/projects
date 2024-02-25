#!/bin/bash

# our program goal is to install mysql

DATE=$(date +%F:H:M:S)
SCRIPT_NAME=$0
LOGFILE=/tmp/$SCRIPT_NAME-$DATE.log

R="\e[31m"
G="\e[32m"
N="\e[0m"
USERID=$(id -u)

if [ $USERID -ne 0 ]
then
    echo "ERROR:: Please run this script with root access"
    exit 1
# else
#     echo "INFO:: You are root user"
fi
# this function should VALIDATE the previous command and inform user it is success or failure
VALIDATE(){
    #$1 --> it will receive the argument1
    if [ $1 -ne 0 ];
    then
        echo -e "$2 ... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}



yum install nginx -y &>>$LOGFILE

VALIDATE $? "Installing Nginx package"

systemctl enable nginx &>>$LOGFILE

VALIDATE $? "enabling the nginx"

systemctl start nginx &>>$LOGFILE

VALIDATE $? "starting nginx"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE
VALIDATE $? "removing the default html files"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>>$LOGFILE

VALIDATE $? " downloading web artifact"

cd /usr/share/nginx/html &>>$LOGFILE

VALIDATE $? "moving to default htmldirectory"

unzip /tmp/web.zip &>>$LOGFILE

VALIDATE $? "unzipping"

cp /home/centos/projects/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$LOGFILE
VALIDATE $? "coping roboshop.config"


systemctl restart nginx &>>$LOGFILE

VALIDATE $? "restarting"