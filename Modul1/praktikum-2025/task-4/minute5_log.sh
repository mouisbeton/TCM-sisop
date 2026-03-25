#!/bin/bash

home_path="/home/mouis/"
metric_path="/home/mouis/metrics"
timestamp=$(date +"%Y%m%d%H%M%S")
mkdir -p "$metric_path"

memory=$(free -m | awk 'NR==2{printf "%s,%s,%s,%s,%s,%s", $2,$3,$4,$5,$6,$7}')
swap=$(free -m | awk 'NR==3{printf "%s,%s,%s", $2,$3,$4}')
dir_size=$(du -sh "$home_path" | awk '{print $1}')

log_file="$metric_path/metrics_$timestamp.log"

echo "mem_total,mem_used,mem_free,mem_shared,mem_buff,mem_available,swap_total,swap_used,swap_free,path,path_size" > "$log_file"
echo "$memory,$swap,$home_path,$dir_size" >> "$log_file"

chmod 600 "$log_file"