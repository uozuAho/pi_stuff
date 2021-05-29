#!/bin/bash
#
# Stream video from a camera module over TCP
#
# You can watch the stream in VLC by opening tcp/h264://pi.address:3333

PORT=3333
LOCAL_IP=`ip -4 addr show wlan0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'`
# video settings
ROTATE_DEGREES=90
WIDTH=800
HEIGHT=600
# Note about fps: anything but default (25?) will cause VLC playback to
# stutter. Configure VLC playback framerate via tools -> preferences ->
# video -> input/codecs -> demuxers -> h264
# FPS=25

echo View stream at tcp/h264://${LOCAL_IP:-whats.my.ip.address?}:$PORT

raspivid -l -o tcp://0.0.0.0:$PORT -t 0 \
    -rot $ROTATE_DEGREES \
    --exposure night \
    --flicker 50hz \
    -w $WIDTH \
    -h $HEIGHT

# -fps $FPS
