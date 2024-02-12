#!/bin/bash
userid=$(id -u)
date=$(date +%F)
logfile=/tmp/$filename-$date.log
R="\e[31m" #red colour
G="\e[32m" #green colour
Y="\e[33m" #yellow colour
N="\[0m" # No Color

if [  $userid -ne 0 ]
then
    echo " $R error: you must run this script as root user.$N"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ]

    then
        echo "$2 is $R failure $N"
        exit 1
    else
        echo "$2 is $G success $N"
    fi

}



 for i in $@
 do 
    yum list installed $i &>> $logfile
    if [ $? -ne 0 ]
    then
        yum install $i -y &>> $logfile
        
        VALIDATE $? "Installing package $i"
    else
        "$y it is already installed $i"
    fi
done