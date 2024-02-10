#!/bin/bash
 # As a devops engineer, we should keep the logfiles in separate folder by using redirections ">".

 # We can use ">>" to append logs instead of overwriting them.
 # >  ---> redirect the log
 # 1> ---> success eg: (ls -l 1> cat.log) "it prints if it is success only. It will not print any error messages."
 # 2> ---> error/failure
 # &> ---> it will store both the logs success and failure.it prints only current command(overwrites)
# &>> ---> it will store both the logs success and failure.(appends)



Date=$(date +%F-%H-%M-%S)
userid=$(id -u)
filename=$0
logfile=/tmp-$filename-$Date.log
R="\e31m"
G="\e32m"
Y="\e33m"
N="\e0m"


VALIDATE(){

    if [ $1 -ne 0 ]

    then 
        echo -e  "$2  IS $R FAILURE $N "
        exit 1
    else
        echo -e "$2  is $G SUCCESS $N "
    fi
}

if [ $userid -ne 0 ]
then 
    echo "You need to run this script as root."
    exit 1 #1-127 anything is error(exit status), 0 means success.
    
fi

yum install mysql -y &>> logfile

#$1 is first arugument $2 is second arguement  and so on...

VALIDATE $? "installing mysql"

yum install postfix -y &>> logfile

VALIDATE $? "installing postfix"