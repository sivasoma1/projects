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

cp /home/centos/projects/mongo.repo vim /etc/yum.repos.d/mongo.repo &>>$log_file

validate $? "cpopingy the mongo.repo file"

yum install mongodb-org -y  &>>$log_file

validate $? "installing mongodb"

systemctl enable mongod &>>$log_file


validate $? "enabling mongodb"

systemctl start mongod &>>$log_file

validate $? "starting mongodb"

sed -i '/s/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>>$log_file

validate $? " updating"


systemctl restart mongod &>>$log_file

validate $? "restarting"