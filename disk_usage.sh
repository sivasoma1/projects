#!/bin/bash
log_file_dir=/tmp
Date=$(date +%F:%H:%M:%S)
Filename=$0
log_file=$log_file_dir/$Filename-$Date.log

Disk_Usage=$(df -hT | grep -vE 'tmpfs|Filesystem')
Disk_Threshold=1
 
#IFS means internal field separator

while IFS= read line
do
# it is for to check the disk usage
    Usage=($(echo $line | awk '{print $7}' | cut -d % -f1))
    
   #Checking if the usage is greater than threshold, then send an email 
    partion=($(echo $line | awk '{print $1}'))

    if [ "$Usage" -ge "$Disk_Threshold" ]; then
        echo "WARNING: Disk usage is over threshold of $Disk_Threshold%. Current

    fi
    
done <<< $Disk_Usage



