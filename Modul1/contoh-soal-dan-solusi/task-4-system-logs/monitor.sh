#!/bin/bash
# Contoh Solusi 4 - Monitor system metrics

RAM_USED=$(free -m | awk 'NR==2 {print $3}')
FOLDER_SIZE=$(du -sh /tmp | awk '{print $1}')
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
LOG_FILE="metrics_$(date +%Y%m%d).log"

echo "$TIMESTAMP | ${RAM_USED}MB | $FOLDER_SIZE" >> "$LOG_FILE"

echo "Log tersimpan: $LOG_FILE"
