#!/bin/bash
log_file_dir=/tmp
Date=$(date +%F:%H:%M:%S)
Filename=$0
log_file=$log_file_dir/$Filename-$Date.log

Disk_Usage=$(df -hT | grep -vE 'tmpfs|Filesystem')
Disk_Threshold=1
message=""
#IFS means internal field separator

while IFS= read line
do
# it is for to check the disk usage
    Usage=$(echo $line | awk '{print $6}' | cut -d % -f1)
    
   #Checking if the usage is greater than threshold, then send an email 
    partition=$(echo $line | awk '{print $1}')

    if [ $Usage -gt $Disk_Threshold ]; 
    then
        message+="WARNING: $partition has reached its limit. $Usage \n "
        

    fi
    
done <<< $Disk_Usage

echo -e "message:$message"
echo "message" | mail -s "high alert" sivanaidusoma@gmail.com



