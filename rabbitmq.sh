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

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh &>>$log_file| bash
validate $? "downloading  rabbitMQ repo script"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$log_file
validate $? "downloading  rabbitMQ repo script"
yum install rabbitmq-server -y  &>>$log_file
validate $? "Installing RabbitMQ Server"
systemctl enable rabbitmq-server &>>$log_file
validate $? "enabling"
systemctl start rabbitmq-server &>>$log_file
validate $? "starting"
rabbitmqctl add_user roboshop roboshop123 &>>$log_file
validate $? "creating user and passwd"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$log_file
validate $? "permissions"