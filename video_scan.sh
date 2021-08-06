#!/bin/bash
# Scan videos for motion, output results to new videos.
# Requires dvr-scan: https://dvr-scan.readthedocs.io/en/latest/
#
# Note that this is pretty resource-heavy. Some stats:
#
# Scanning an 800x600 video:
# - my ryzen 5 3600 desktop: ~300 frames/sec. Approx 1 min to scan 30 min footage.
# - raspberry pi 2: ~6 frames/sec. Approx 40 min to scan 30 min footage.
#
# # Installing dvr-scan on a Raspberry Pi:
# ```sh
# sudo apt-install python3-opencv
# pip3 install dvr-scan
#
# # if you get `libf77blas.so.3: cannot open shared object file: No such file or directory`
# # when running dvr-scan:
# pip3 uninstall numpy
# apt install python3-numpy
# ```
#
# Note that dvr-scan is currently CPU-bound. See https://github.com/Breakthrough/DVR-Scan/issues/12

set -e

VIDEOS_DIR=/s/zz_woz_stuff/mousecam
OUTPUT_DIR=/s/zz_woz_stuff/mousecam/scanned
# Lower = more sensitive. Default = 0.15
MOTION_THRESHOLD=0.05
# delete the source video after scanning
DELETE_AFTER_SCAN=yes

# prevent processing 0 files (bad things happen)
if [ `find $VIDEOS_DIR -iname "*.h264" | wc -l` -eq '0' ]; then
    echo no videos!
    exit
fi

mkdir -p $OUTPUT_DIR

for raw_vid in $VIDEOS_DIR/*.h264; do
    out_path=$OUTPUT_DIR/`basename $raw_vid`.mp4
    dvr-scan -i $raw_vid -o $out_path -t $MOTION_THRESHOLD
    if [[ $DELETE_AFTER_SCAN == "yes" ]]; then
        rm $raw_vid
    fi
done
