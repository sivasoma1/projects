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

