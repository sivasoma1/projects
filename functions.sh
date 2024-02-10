#!/bin/bash

#functions will do some work behalf of us, it updates
#we need to give inputs,function will give output
userid=$(id -u)

VALIDATE(){

    if [ $1 -ne 0]

    then 
        echo "INSTALLATION...... IS FAILURE "
        exit 1
    else
        echo "installation is SUCCESS  "
    fi
}

if [ $userid -ne 0 ]
then 
    echo "You need to run this script as root."
    exit 1 #1-127 anything is error(exit status), 0 means success.
    
fi

yum install mysql -y

VALIDATE $?

yum install postfix -y

VALIDATE $?




