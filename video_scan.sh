#!/bin/bash
# Scan videos for motion, output results to new videos.
# Requires dvr-scan: https://dvr-scan.readthedocs.io/en/latest/
#
# Note that this is pretty resource-heavy.

VIDEOS_DIR=/s/zz_woz_stuff/mousecam
OUTPUT_DIR=/s/zz_woz_stuff/mousecam

for raw_vid in $VIDEOS_DIR/*.h264; do
    out_path=$OUTPUT_DIR/`basename $raw_vid`.mp4
    dvr-scan -i $raw_vid -o $out_path
done
