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

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$LOGFILE
VALIDATE $? "downloading  rabbitMQ repo script"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$LOGFILE
VALIDATE $? "downloading  rabbitMQ repo script"

yum install rabbitmq-server -y  &>>$LOGFILE
VALIDATEIDATE $? "Installing RabbitMQ Server"

systemctl enable rabbitmq-server &>>$LOGFILE
VALIDATEIDATE $? "enabling"

systemctl start rabbitmq-server &>>$LOGFILE
VALIDATE $? "starting"

id roboshop &>>$LOGFILE
if [ $? -ne 0 ];
    then
        rabbitmqctl add_user roboshop roboshop123 &>>$LOGFILE
        VALIDATE $? "creating user and passwd"
        
    else
        VALIDATE $? "User roboshop already exists."
        
fi

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOGFILE
VALIDATE $? "permissions"