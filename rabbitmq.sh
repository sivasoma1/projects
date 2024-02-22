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

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
validate $? "downloading  rabbitMQ repo script"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash
validate $? "downloading  rabbitMQ repo script"
yum install rabbitmq-server -y 
validate $? "Installing RabbitMQ Server"
systemctl enable rabbitmq-server
validate $? "enabling"
systemctl start rabbitmq-server
validate $? "starting"
rabbitmqctl add_user roboshop roboshop123
validate $? "creating user and passwd"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
validate $? "permissions"