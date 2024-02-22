#!/bin/bash

log_dir=/tmp
Date=$(date +%F:H:M:S)
filename=$0
log_file=$log_dir/$filename-$Date.log
userid = $(id -u)

$R= "\e[31m"

$G= "\e[32m"

$Y= "\e[33m"

$N= "\e[0m"



if [ $userid -ne 0 ];
    then
        echo "Error: $R Root user $N"
        exit 1
fi
validate() {

    if [ $1 -ne 0 ];
        then 
            echo "$1 $R Failure $N"
            exit 1
        else
            echo "$1 $G Success $N"
    fi
}

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
