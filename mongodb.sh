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

cp /home/centos/projects/mongo.repo vim /etc/yum.repos.d/mongo.repo &>>$LOGFILE

validate $? "cpopingy the mongo.repo file"

yum install mongodb-org -y  &>>$LOGFILE

validate $? "installing mongodb"

systemctl enable mongod &>>$LOGFILE


validate $? "enabling mongodb"

systemctl start mongod &>>$LOGFILE

validate $? "starting mongodb"

sed -i '/s/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>>$LOGFILE

validate $? " updating"


systemctl restart mongod &>>$LOGFILE

validate $? "restarting"