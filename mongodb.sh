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

cp /home/centos/projects/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE

VALIDATE $? "cpopingy the mongo.repo file"

yum install mongodb-org -y  &>>$LOGFILE

VALIDATE $? "installing mongodb"

systemctl enable mongod &>>$LOGFILE


VALIDATE $? "enabling mongodb"

systemctl start mongod &>>$LOGFILE

VALIDATE $? "starting mongodb"

sed -i '/s/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>>$LOGFILE

VALIDATE $? " updating"


systemctl restart mongod &>>$LOGFILE

VALIDATE $? "restarting"