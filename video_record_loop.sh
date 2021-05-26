#/bin/bash
#
# Continuously records video files of the configured duration
# until stopped by an external signal, eg. ctrl-c

set -eu

# output dir
RECORD_DIR=/home/pi/mousecam
DONE_DIR=$RECORD_DIR/done
# cam/recording settings
ROTATE_DEGREES=90
FPS=10
DURATION_SEC=600

trap stop SIGINT

stop_requested=0

function stop()
{
    stop_requested=1
}

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
      -t $(($DURATION_SEC * 1000))
}

while [ $stop_requested -ne 1 ]
do
    echo "`timestamp`: starting recording"
    start_recording
    mv $RECORD_DIR/*.h264 $DONE_DIR
    echo "`timestamp`: recording exited with status $?"
    sleep 1
done

echo "`timestamp`: reached end of script :)"
