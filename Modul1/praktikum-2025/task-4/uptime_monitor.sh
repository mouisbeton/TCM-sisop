#!/bin/bash

home_path="/home/mouis/"
metric_path_path="/home/mouis/metrics"
timestamp=$(date +"%Y%m%d%H")
mkdir -p "$metric_path_path"

uptime=$(uptime | awk -F ',' '{print $1}')
avg_load=$(cat /proc/loadavg | awk '{print $1","$2","$3}')
log_file="$metric_path_path/uptime_$timestamp.log"
{
echo "uptime,load_avg_1min,load_avg_5min,load_avg_15min"
echo "$uptime, $avg_load"
} > "$log_file"

chmod 600 "$log_file"