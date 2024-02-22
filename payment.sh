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

yum install python36 gcc python3-devel -y
validate $? "installing python"

useradd roboshop
validate $? "useradd"

mkdir /app 

validate $? "creating an app directory"

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip

validate $? "downloading payment module"

cd /app 
validate $? "changing to the app dir"

unzip /tmp/payment.zip
validate $? "unzipping"

cd /app 
validate $? "changing  back to the app dir"


pip3.6 install -r requirements.txt

validate $? "Installing Python dependencies with pip"

cp /home/centos/projects/payment.service /etc/systemd/system/payment.service
validate $? "coping"

systemctl daemon-reload
validate $? "daemon"

systemctl enable payment
validate $? "enable"

systemctl start payment

validate $? "starting"
