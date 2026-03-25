awk -F ',' '
        $2 ~ /2/ && $2 !~ /_/ {print $2}
        ' newjeans_analysis/DataStreamer.csv | sort -V
awk -F ',' '
        BEGIN {count=0} $2 ~ /2/ && $2 !~ /_/ {count++} 
        END{print "jumlah nama: "count}
        ' newjeans_analysis/DataStreamer.csv