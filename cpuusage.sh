#!/bin/bash

printf "Memory\t\tDisk\t\tCPU\n" > /tmp/mem
end=$((SECONDS+20))
m=5
while [ $SECONDS -lt $end ];
do
        MEMORY=$(free -m | awk 'NR==2{printf "%.2f%%\t\t", $3*100/$2 }')
        DISK=$(df -h | awk '$NF=="/"{printf "%s\t\t", $5}')
        CPU=$(top -bn1 | grep load | awk '{printf "%.2f%%\t\t\n", $(NF-2)}')
        echo "$MEMORY$DISK$CPU" >> /tmp/mem
        cpuuse=$(cat /proc/loadavg | awk '{print $3}'|cut -f 1 -d ".")
        memuse=$(free -m | awk 'NR==2{printf "%.2f%%\t\t", $3*100/$2 }' | cut -f 1 -d ".")
        diskuse=$(df -h | awk '$NF=="/"{printf "%s\t\t", $5}' | cut -f 1 -d "%")
        if [ $cpuuse -lt 0 ] || [ $memuse -gt 10 ] || [ $diskuse -lt 20 ];
        then
                SUBJECT="ATTENTION: Memory/disk space/cpu is high on $(hostname) at $(date)"
                msg=$(echo Memory used is $MEMORY, CPU is $CPU, Disk consumed $DISK)
                mail -s "$SUBJECT" rahul3.sharma@lntinfotech.com <<< "$msg"
        else
          echo all resources are under limit
        fi
sleep 5
done
