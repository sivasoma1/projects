#!/bin/bash

#functions will do some work behalf of us, it updates
#we need to give inputs,function will give output
userid=$(id -u)
validate (){
    if [ $1 -ne 0]
    then 
        echo "the statement is error :please check the given command"
    else
        echo "installation is success $@"
}

if [ $userid -ne 0 ]
then 
    echo "You need to run this script as root."
    exit 1 #1-127 anything is error(exit status), 0 means success.
fi
validate $?
yum install mysql -y

validate $?
yum install mysql -y




