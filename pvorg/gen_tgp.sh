#!/bin/bash

get_ffmpeg_layout_string() {
    local index=$1
    local cols=$2

    local col=$((index % cols))
    local row=$((index / cols))

    local col_layout=()
    if [ "$col" -eq 0 ]; then
        col_layout=("0")
    else
        for (( j=0; j<col; j++ )); do
            col_layout+=("w0")
        done
    fi

    local row_layout=()
    if [ "$row" -eq 0 ]; then
        row_layout=("0")
    else
        for (( j=0; j<row; j++ )); do
            row_layout+=("h0")
        done
    fi

    col_layout=$(IFS="+"; echo "${col_layout[*]}")
    row_layout=$(IFS="+"; echo "${row_layout[*]}")
    echo "${col_layout}_${row_layout}"
}

generate_tiled_image() {
    local input_path=$1
    local timestamps=("${!2}")
    local streams=("${!3}")
    local layouts=("${!4}")
    local cols=$5
    local width=$6
    local output_path=$7

    local ffmpeg_command="/opt/homebrew/bin/ffmpeg"

    for timestamp in "${timestamps[@]}"; do
        ffmpeg_command+=" -ss $timestamp -i $input_path"
    done

    local num_inputs=${#timestamps[@]}
    local scale_width=$((cols * width))

    local streams=$(IFS=; echo "${streams[*]}")
    local layouts=$(IFS="|"; echo "${layouts[*]}")
    ffmpeg_command+=" -frames:v 1 -y -filter_complex '${streams}xstack=inputs=$num_inputs:layout=${layouts}[v];[v]scale=$scale_width:-1[scaled]' -map [scaled] $output_path"

    eval $ffmpeg_command
}

video_path=$1
img_dir=$2
cols=4
rows=4
duration=$(/opt/homebrew/bin/ffprobe -v error -select_streams v:0 -show_entries stream=duration -of default=noprint_wrappers=1:nokey=1 "$video_path")
#width=$(/opt/homebrew/bin/ffprobe -v error -select_streams v:0 -show_entries stream=width -of default=noprint_wrappers=1:nokey=1 "$video_path")
width=1500

img_name=$(basename "$video_path").jpg
num_tiles=$((cols * rows))
time_slice=$(echo "$duration * 1000 / $num_tiles" | bc -l)
time_slice=$(echo "$time_slice/1000" | bc)
offset=$((time_slice / 2))

timestamps=()
streams=()
layouts=()

for (( i=0; i<num_tiles; i++ )); do
    total_seconds=$(echo "$offset + $i * $time_slice" | bc)
    total_seconds=$(echo "$total_seconds" | awk '{print int($1)}')
    hours=$((total_seconds / 3600))
    minutes=$(( (total_seconds % 3600) / 60 ))
    seconds=$((total_seconds % 60))
    timestamp=$(printf "%d:%d:%d" $hours $minutes $seconds)
    timestamps+=("$timestamp")
    streams+=("[$i:v]")
    layouts+=("$(get_ffmpeg_layout_string $i $cols)")
done

generate_tiled_image "$video_path" timestamps[@] streams[@] layouts[@] "$cols" "$width" "$img_dir/$img_name"
