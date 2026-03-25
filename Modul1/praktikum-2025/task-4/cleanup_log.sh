#!/bin/bash

log_path="/home/mouis/metrics"
find "$log_path" -name "metrics_agg_*.log" -type f -mmin +720 -exec rm -f {} \;