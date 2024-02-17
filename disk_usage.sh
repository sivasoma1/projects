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
    echo "output: $line"
done <<< $Disk_Usage