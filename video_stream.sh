#!/bin/bash
#
# Stream video from a camera module over TCP
#
# You can watch the stream in VLC by opening tcp/h264://pi.address:3333

PORT=3333

raspivid -l -o tcp://0.0.0.0:$PORT -t 0
