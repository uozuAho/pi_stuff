#!/bin/bash
#
# See video_scan.sh for more details.

set -e

VIDEOS_DIR=/s/zz_woz_stuff/mousecam
OUTPUT_DIR=/s/zz_woz_stuff/mousecam/scanned
# Lower = more sensitive. Default = 0.15
MOTION_THRESHOLD=0.05
# delete the source video after scanning
DELETE_AFTER_SCAN=yes

video_to_scan=$(find $VIDEOS_DIR -iname "*.h264" | head -n 1)

if [[ -z $video_to_scan ]]; then
    echo no videos!
    exit
fi

mkdir -p $OUTPUT_DIR
out_path=$OUTPUT_DIR/`basename $video_to_scan`.mp4
echo dvr-scan -i $video_to_scan -o $out_path -t $MOTION_THRESHOLD
if [[ $DELETE_AFTER_SCAN == "yes" ]]; then
    rm $video_to_scan
fi
