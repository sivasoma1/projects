#!/bin/bash
userid=$(id -u)
date=$(date +%F)
logfile=/tmp/$filename-$date.log
R="\e[31m" #red colour
G="\e[32m" #green colour
Y="\e[33m" #yellow colour
N="\[0m" # No Color

VALIDATE(){
    if [ $1 -ne 0 ]

    then
        echo "$2"

}
 for i in $@
 do 
    yum install $i -y
done