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



yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$log_file

validate $? "installing packages redis"

yum module enable redis:remi-6.2 -y &>>$log_file
validate $? "enabling"


yum install redis -y &>>$log_file

validate $? "installing"


sed -i '/s/127.0.0.1/0.0.0.0/g' /etc/redis.conf /etc/redis/redis.conf &>>$log_file

validate $? "changing bind address to 0.0.0.0 in config file"

systemctl enable redis &>>$log_file
validate $? "enabling"



systemctl start redis &>>$log_file
validate $? "starting service"
