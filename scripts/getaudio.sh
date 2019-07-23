#!/bin/sh
# Extract audio from a video file using ffmpeg.

if [ "$#" -lt 1 ]; then
    echo 'You need to specify a video.'
    return 1
elif [ "$#" -gt 1 ]; then
    echo 'Too many arguments.'
    return 1
elif [ ! -f "$1" ]; then
    echo 'File does not exist.'
    return 1
fi

video_path="$1"
# Get path without extension to be later saved as audio.
no_extension="${video_path%.*}"

extension="$(
    ffprobe -v quiet -show_streams -print_format xml -hide_banner "$video_path" |
    xmllint --noent --xpath 'string(//stream[2]/@codec_name)' -
)"

ffmpeg -i "$video_path" -vn -acodec copy "$no_extension.$extension"
