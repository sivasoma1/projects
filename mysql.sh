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

yum module disable mysql -y &>>$log_file

validate $? "Disabling MySQL YUM Module"

cp /home/centos/projects/mysql.repo /etc/yum.repos.d/mysql.repo &>>$log_file
validate $? "coping"

yum install mysql-community-server -y &>>log_file
validate $? "installing"

systemctl enable mysqld &>>log_file
validate $? "enable"



systemctl start mysqld &>>log_file
validate $? "starting"

mysql_secure_installation --set-root-pass RoboShop@1
validate $? "Setting root password for MySQL Server"

mysql -uroot -pRoboShop@1
validate $? "Logging into MySQL as root with the new password"
