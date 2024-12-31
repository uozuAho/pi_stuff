# Motion camera

Speed run set up of a raspberry pi zero W, camera + motion software, to run
a networked motion detecting camera. For more details, see ../motion.md

# Steps
- build the camera hardware: https://github.com/uozuAho/pi_cam_v2
- On dev machine
    - download imager: https://www.raspberrypi.com/software/
    - get pi OS lite from: https://www.raspberrypi.com/software/operating-systems/
    - set up SD card with imager. username = woz, hostname = piw.local,
      enable networking + ssh
    - plug in SD, turn on pi, wait a few minutes
    - `ssh woz@piw.local`
- run `pi_setup.sh` on the pi
- set filesystem to readonly with raspi-config:
    - `sudo raspi-config`
    - perf options
    - enable filesystem overlay (takes ~10 minutes)
