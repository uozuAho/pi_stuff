""" Take photos every PERIOD_S, between TIME_MIN and TIME_MAX
    Requirements:
    raspi-config  # -> enable camera
    sudo apt-get install python-picamera
    # make sure your local time is correct:
    sudo dpkg-reconfigure tzdata

    Usage:

    On the pi, run `nohup python timelapse.py &` to run in the background.
    Can then logout and photos will continue.
    To kill this process, run `killall python`.
    To check that no other python programs are running, run `ps -ef | grep python`
"""

import picamera
import datetime
import time
import os

OUTPUT_DIR = "/media/share/some_dir"
PERIOD_S = 300
TIME_MIN = datetime.time(6, 00, 0)
TIME_MAX = datetime.time(20, 15, 0)

c = picamera.PiCamera(resolution=(2592,1944))
# camera sitting upside-down on tripod
c.rotation = 180

while True:
    timestr = datetime.datetime.now().strftime("%Y%m%d-%H%M%S")
    filename = "img_{}.jpg".format(timestr)
    opath = os.path.join(OUTPUT_DIR, filename)
    now = datetime.datetime.now().time()
    if now > TIME_MIN and now < TIME_MAX:
        c.capture(opath)
    time.sleep(PERIOD_S)
