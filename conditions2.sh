#!/bin/bash

userid=$(id -u)
if [ $userid -ne 0 ]
then 
    echo "You need to run this script as root."
    exit 1 #1-127 anything is error(exit status), 0 means success.
fi
yum install mysql -y

if [ $? -eq 0 ]; then
        echo "MySQL has been installed successfully!"
else
	echo "Failed to install MySQL"
	exit 1
fi
yum install postfix -y

if [ $? -eq 0 ]; then
        echo "MySQL has been installed successfully!"
else
	echo "Failed to install postfix"
	exit 1
fi