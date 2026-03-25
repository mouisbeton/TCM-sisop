songs=$(awk -F ',' '
        $2 ~ /[0-9]/ {print $3} 
        ' newjeans_analysis/DataStreamer.csv |sort -V | uniq -c | sort -nr)

hit_song=$(echo "$songs" | head -n 1)

song_name=$(echo "$hit_song" | awk '{print $2}') 
user_count=$(echo "$hit_song" | awk '{print $1}')

echo $song_name $user_count
if [ $user_count -ge 24 ]; 
then
    echo "Keren, Minji! Kamu hebat <3!"
else
    echo "Maaf, Minji, total streamingnya tidak sesuai harapan :("
fi