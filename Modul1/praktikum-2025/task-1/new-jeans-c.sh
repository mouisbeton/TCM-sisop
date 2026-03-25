songs=$(awk -F ',' '
		$2 ~ /[0-9]/ {print $3} 
		' newjeans_analysis/DataStreamer.csv | sort -V | uniq -c | sort -nr)

hit_song=$(echo "$songs" | head -n 1)

song_name=$(echo "$hit_song" | awk '{print $2}')
user_count=$(echo "$hit_song" | awk '{print $1}') 

awk -F ',' -v song="$song_name" -v user="$user_count" '
		$2 ~ song {print $2, ":", user, "\n", $1, $3}
		' newjeans_analysis/AlbumDetails.csv
