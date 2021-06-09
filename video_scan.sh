#!/bin/bash
# Scan videos for motion, output results to new videos.
# Requires dvr-scan: https://dvr-scan.readthedocs.io/en/latest/
#
# Note that this is pretty resource-heavy.

set -e

VIDEOS_DIR=/s/zz_woz_stuff/mousecam
OUTPUT_DIR=/s/zz_woz_stuff/mousecam
# Lower = more sensitive. Default = 0.15
MOTION_THRESHOLD=0.05
# delete the source video after scanning
DELETE_AFTER_SCAN=yes

# prevent processing 0 files (bad things happen)
if [ `find $VIDEOS_DIR -iname "*.h264" | wc -l` -eq '0' ]; then
    echo no videos!
    exit
fi

for raw_vid in $VIDEOS_DIR/*.h264; do
    out_path=$OUTPUT_DIR/`basename $raw_vid`.mp4
    dvr-scan -i $raw_vid -o $out_path -t $MOTION_THRESHOLD
    if [[ $DELETE_AFTER_SCAN == "yes" ]]; then
        rm $raw_vid
    fi
done
