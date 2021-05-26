#/bin/bash

RECORD_DIR=/home/pi/mousecam
DONE_DIR=$RECORD_DIR/done

trap stop SIGINT

stop_requested=0

function stop()
{
    stop_requested=1
}

function timestamp()
{
    date +"%Y-%m-%d__%H:%M:%S"
}

function start_recording()
{
    raspivid -o $RECORD_DIR/`timestamp`.h264 -rot 90 -fps 5 -t 600000
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
