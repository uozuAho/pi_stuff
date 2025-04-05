#!/bin/bash

set -eu

USERNAME=woz

function install_pkgs() {
    sudo apt update
    sudo apt install -y motion libcamera-v4l2 libcamera-tools
}

# assumes that /dev/shm is already a tmpfs
function setup_tmpfs() {
    sudo cp /etc/fstab /etc/fstab.tmp.bak
    sudo bash -c \
      "echo \"tmpfs   /var/log    tmpfs   defaults,noatime,nosuid,mode=0755,size=50M   0 0\" \
      >> /etc/fstab"
    sudo mount -a
    systemctl daemon-reload
}

function setup_network_share() {
    sudo mkdir -p /media/share
    sudo chown $USERNAME /media/share
    sudo chgrp $USERNAME /media/share
    uid=$(id -u $USERNAME)
    gid=$(id -g $USERNAME)
    user=booz
    read -s -p "enter share drive password: " pw
    sudo cp /etc/fstab /etc/fstab.net.bak
    sudo bash -c \
      "echo \"//192.168.1.100/share /media/share cifs defaults,rw,uid=$uid,gid=$gid,username=$user,password=$pw,vers=2.0\" \
      >> /etc/fstab"
    echo ""
    echo "Attempting to mount. Check ls /media/share ..."
    sudo mount -a
    systemctl daemon-reload
}

function check_camera() {
    echo "CAMERA CHECK"
    echo "Copy motion config from https://github.com/uozuAho/pi_stuff/"
    echo "to motion.littlethings.conf, then press any key."
    read -p "After pressing a key, browse to http://piw.local:8080 to see the camera feed"
    libcamerify motion -c motion.littlethings.conf

    read -p "When done, press a key, then run killall motion"
}

function setup_cron() {
temp=$(cat << EOF
*/1 * * * * mv /dev/shm/mopics/* /media/share/zz_woz_stuff/mopics/
0 0 * * * libcamerify motion -c /home/woz/motion.littlethings.conf
0 8 * * * killall motion
EOF
)
echo "$temp" | crontab -
}

setup_tmpfs
install_pkgs
check_camera
setup_network_share
setup_cron
