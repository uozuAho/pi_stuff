#!/bin/bash

set -eu

function install_pkgs() {
    sudo apt update
    sudo apt install -y motion libcamera-v4l2 libcamera-tools
}

function setup_network_share() {
    sudo mkdir -p /media/share
    sudo chown $USERNAME /media/share
    sudo chgrp $USERNAME /media/share
    uid=$(id -u $USERNAME)
    gid=$(id -g $USERNAME)
    user=booz
    read -s -p "enter share drive password: " pw
    sudo cp /etc/fstab /etc/fstab.bak
    sudo bash -c \
      "echo \"//192.168.1.100/share /media/share cifs defaults,rw,uid=$uid,gid=$gid,username=$user,password=$pw,vers=2.0\" \
      >> /etc/fstab"
    sudo mount -a
    # todo: systemd restart?
}

function check_camera() {
    echo "CAMERA CHECK"
    read -p "Copy motion config from https://github.com/uozuAho/pi_stuff/ \n \
    to motion.littlethings.conf, then press any key..."
    read -p "After pressing a key, browse to http://piw.local:8080 to see the camera feed"
    libcamerify motion -c motion.littlethings.conf
}

function setup_cron() {
cat << EOF
*/1 * * * * mv /home/woz/mopics/* /media/share/zz_woz_stuff/mopics/
0 0 * * * libcamerify motion -c /home/woz/motion.conf
0 8 * * * killall motion
EOF | crontab -
}

install_pkgs
check_camera
setup_network_share
setup_cron
