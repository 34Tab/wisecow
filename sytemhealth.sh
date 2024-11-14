#!/bin/bash

# Thresholds
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80
PROCESS_THRESHOLD=300

# Color codes for alerts
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

while true; do
    clear
    echo "=== System Health Monitor ==="
    echo "Time: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "----------------------------"

    # Check CPU usage
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | awk -F. '{print $1}')
    echo -n "CPU Usage: ${CPU_USAGE}% "
    if [ ${CPU_USAGE} -gt ${CPU_THRESHOLD} ]; then
        echo -e "${RED}[ALERT] High CPU usage!${NC}"
    else
        echo -e "${GREEN}[OK]${NC}"
    fi

    # Check Memory usage
    MEMORY_USAGE=$(free | grep Mem | awk '{print ($3/$2) * 100.0}' | awk -F. '{print $1}')
    echo -n "Memory Usage: ${MEMORY_USAGE}% "
    if [ ${MEMORY_USAGE} -gt ${MEMORY_THRESHOLD} ]; then
        echo -e "${RED}[ALERT] High memory usage!${NC}"
    else
        echo -e "${GREEN}[OK]${NC}"
    fi

    # Check Disk usage
    DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
    echo -n "Disk Usage: ${DISK_USAGE}% "
    if [ ${DISK_USAGE} -gt ${DISK_THRESHOLD} ]; then
        echo -e "${RED}[ALERT] High disk usage!${NC}"
    else
        echo -e "${GREEN}[OK]${NC}"
    fi

    # Check Process count
    PROCESS_COUNT=$(ps aux | wc -l)
    echo -n "Process Count: ${PROCESS_COUNT} "
    if [ ${PROCESS_COUNT} -gt ${PROCESS_THRESHOLD} ]; then
        echo -e "${RED}[ALERT] Too many processes!${NC}"
    else
        echo -e "${GREEN}[OK]${NC}"
    fi

    # Show top 5 CPU-consuming processes if there's high CPU usage
    if [ ${CPU_USAGE} -gt ${CPU_THRESHOLD} ]; then
        echo -e "\nTop 5 CPU-consuming processes:"
        ps aux --sort=-%cpu | head -6 | awk 'NR==1{print $1,"\t",$2,"\t",$3,"\t",$4,"\t",$11} NR>1{print $1,"\t",$2,"\t",$3,"\t",$4,"\t",$11}'
    fi

    sleep 5
done
