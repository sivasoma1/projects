#!/bin/bash

APP_LOGS_DIR="/home/centos/app_logs"
DATE=$(date +%F:%H:%M:%S)
LOGSDIR="/home/centos/shellscript-logs"
# /home/centos/shellscript-logs/script-name-date.log

SCRIPT_NAME="$(basename "$0")"  # script name without the path "basename get the file  name only"
LOGFILE="$LOGSDIR/$SCRIPT_NAME-$DATE.log"
FILES_TO_DELETE=$(find "$APP_LOGS_DIR" -name "*.log" -type f -mtime +14)

if [ -z "$FILES_TO_DELETE" ]; then
    
   exit 0
   else


fi

echo "script started executing at $DATE" &>> "$LOGFILE"

for file in $FILES_TO_DELETE; do
    echo "Deleting $file" &>> "$LOGFILE"
    rm -f "$file"
done