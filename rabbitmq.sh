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

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh &>>$LOGFILE| bash
validate $? "downloading  rabbitMQ repo script"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$LOGFILE
validate $? "downloading  rabbitMQ repo script"
yum install rabbitmq-server -y  &>>$LOGFILE
validate $? "Installing RabbitMQ Server"
systemctl enable rabbitmq-server &>>$LOGFILE
validate $? "enabling"
systemctl start rabbitmq-server &>>$LOGFILE
validate $? "starting"
rabbitmqctl add_user roboshop roboshop123 &>>$LOGFILE
validate $? "creating user and passwd"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOGFILE
validate $? "permissions"