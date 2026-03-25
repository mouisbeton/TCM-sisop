devices=$(awk -F ',' '
    NR>1 {count[$7]+=1}{sum[$7]+=$4}
    END {for (device in count) {
            print count[device],",",sum[device],"seconds,", device;
        }
    }' newjeans_analysis/DataStreamer.csv) 
    
loyal=$(awk -F ',' '
    NR>1 {count[$7]+=1}{sum[$7]+=$4}
    END {for (device in count) {
            print sum[device]/count[device],"seconds per user,", device; 
        }
    }' newjeans_analysis/DataStreamer.csv) 
echo "$devices"
echo "--------"
echo "$devices" | awk -F ',' '{print "Top users: ",$1",",$3}' | sort -k 3 -nr | head -n 1
echo "$devices" | awk -F ',' '{print "Top durations: ",$2,",",$3}' | sort -nr | head -n 1
most_loyal=$(echo "$loyal" | sort -nr | head -n 1)
echo "Most loyal: $most_loyal"
