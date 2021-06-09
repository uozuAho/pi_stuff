#/bin/bash
#
# Continuously records video files of the configured duration
# until stopped by an external signal, eg. ctrl-c
#
# To run in the background, run nohup bash ./video_record_loop.sh
# note that you can't ctrl-c from here, as it terminates... why?
# just disconnect.
#
# Note that recorded videos are raw h264. You can use gpac/mp4box
# to convert them to videos playable by most media players.

set -eu

# output dir
RECORD_DIR=/home/pi/mousecam
DONE_DIR=$RECORD_DIR/done
# record between times
RECORD_TIME_WINDOW_START="00:00"
RECORD_TIME_WINDOW_END="08:00"
# cam/recording settings
ROTATE_DEGREES=0
WIDTH=800
HEIGHT=600
FPS=10
DURATION_SEC=1800

function timestamp()
{
    date +"%Y-%m-%d__%H-%M-%S"
}

function start_recording()
{
    raspivid -o $RECORD_DIR/`timestamp`.h264 \
      -rot $ROTATE_DEGREES \
      -fps $FPS \
      --exposure night \
      --flicker 50hz \
      -t $(($DURATION_SEC * 1000)) \
      -w $WIDTH \
      -h $HEIGHT
}

while true
do
    now=`date +%H:%M`
    if [[ "$now" > $RECORD_TIME_WINDOW_START ]] &&  [[ "$now" < $RECORD_TIME_WINDOW_END ]]; then
        echo "`timestamp`: starting recording"
        start_recording
        mv $RECORD_DIR/*.h264 $DONE_DIR
        echo "`timestamp`: recording exited with status $?"
        sleep 1
    else
        echo "`timestamp`: outside record window, sleeping"
        sleep 300
    fi
done

echo "`timestamp`: reached end of script :)"
