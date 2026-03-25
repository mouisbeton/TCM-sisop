#!/bin/bash

metric_path="/home/mouis/metrics"
timestamp=$(date +"%Y%m%d%H")

log_file="$metric_path/metrics_agg_$timestamp.log"

n=0
mem_total=()
mem_used=()
mem_free=()
mem_shared=()
mem_buff=()
mem_available=()
swap_total=()
swap_used=()
swap_free=()
path_size=()

for file in $(find "$metric_path" -name "metrics_$(date +"%Y%m%d")*.log" -mmin -60); do
    if [ -f "$file" ]; then
        IFS=',' read -r mem_total_val mem_used_val mem_free_val mem_shared_val mem_buff_val mem_available_val swap_total_val swap_used_val swap_free_val _ path_size_val <<< "$(cat "$file" | awk 'NR==2')"
        mem_total+=("$mem_total_val")
        mem_used+=("$mem_used_val")
        mem_free+=("$mem_free_val")
        mem_shared+=("$mem_shared_val")
        mem_buff+=("$mem_buff_val")
        mem_available+=("$mem_available_val")
        swap_total+=("$swap_total_val")
        swap_used+=("$swap_used_val")
        swap_free+=("$swap_free_val")
        path_size+=("${path_size_val//[^0-9]/}")
        n=$((n + 1))
    fi
done

avg(){
    local sum=0
    for val in "${@}"; do
        sum=$((sum + val))
    done
    if ((n != 0)); then
        echo $((sum / n))
    fi
}

max() {
    local max_val="${1}"
    for val in "${@}"; do
        if (( val >= max_val )); then
            max_val="${val}"
        fi
    done
    echo "${max_val}"
}

min() {
    local min_val="${1}"
    shift
    for val in "${@}"; do
        if (( val < min_val )); then
            min_val="${val}"
        fi
    done
    echo "${min_val}"
}

mem_total_max=$(max "${mem_total[@]}") 
mem_used_max=$(max "${mem_used[@]}")
mem_free_max=$(max "${mem_free[@]}")
mem_shared_max=$(max "${mem_shared[@]}")
mem_buff_max=$(max "${mem_buff[@]}")
mem_available_max=$(max "${mem_available[@]}")
swap_total_max=$(max "${swap_total[@]}")
swap_used_max=$(max "${swap_used[@]}")
swap_free_max=$(max "${swap_free[@]}")
path_size_max=$(max "${path_size[@]}")
path_size_max=$((path_size_max * 1024))

mem_total_min=$(min "${mem_total[@]}")
mem_used_min=$(min "${mem_used[@]}")
mem_free_min=$(min "${mem_free[@]}")
mem_shared_min=$(min "${mem_shared[@]}")
mem_buff_min=$(min "${mem_buff[@]}")
mem_available_min=$(min "${mem_available[@]}")
swap_total_min=$(min "${swap_total[@]}")
swap_used_min=$(min "${swap_used[@]}")
swap_free_min=$(min "${swap_free[@]}")
path_size_min=$(min "${path_size[@]}")
path_size_min=$((path_size_min * 1024))

mem_total_avg=$(avg "${mem_total[@]}")
mem_used_avg=$(avg "${mem_used[@]}")
mem_free_avg=$(avg "${mem_free[@]}")
mem_shared_avg=$(avg "${mem_shared[@]}")
mem_buff_avg=$(avg "${mem_buff[@]}")
mem_available_avg=$(avg "${mem_available[@]}")
swap_total_avg=$(avg "${swap_total[@]}")
swap_used_avg=$(avg "${swap_used[@]}")
swap_free_avg=$(avg "${swap_free[@]}")
path_size_avg=$(avg "${path_size[@]}")
path_size_avg=$((path_size_avg * 1024))

{
echo "type,mem_total,mem_used,mem_free,mem_shared,mem_buff,mem_available,swap_total,swap_used,swap_free,path_size"
echo "minimum,$mem_total_min,$mem_used_min,$mem_free_min,$mem_shared_min,$mem_buff_min,$mem_available_min,$swap_total_min,$swap_used_min,$swap_free_min,$path_size_min"M""
echo "maximum,$mem_total_max,$mem_used_max,$mem_free_max,$mem_shared_max,$mem_buff_max,$mem_available_max,$swap_total_max,$swap_used_max,$swap_free_max,$path_size_max"M""
echo "average,$mem_total_avg,$mem_used_avg,$mem_free_avg,$mem_shared_avg,$mem_buff_avg,$mem_available_avg,$swap_total_avg,$swap_used_avg,$swap_free_avg,$path_size_avg"M""
} > "$log_file"

chmod 600 "$log_file"