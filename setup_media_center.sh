# Setting up a media center on rasppi (5)
#
# Manual steps before running this script:
# - install desktop OS, without recommended software
# - get expressvpn deb file (need to log in)
# - check config is up to date
#
# todo: get these working
# - expressvpn
# - share drive
# - netflix
# - freetube
# - iview
# - sbs

set -eu

# -------------------------------------------
# CONFIG

USERNAME=woz
GIT_EMAIL=me@me.me
WOZ_DIR=/home/woz/woz
TEMP_DIR=$WOZ_DIR/temp_setup
EXPRESSVPN_DEB=
EXPRESSVPN_CODE_FILE=
# https://freetubeapp.io/#download
FREETUBE_URL=https://github.com/FreeTubeApp/FreeTube/releases/download/v0.22.0-beta/freetube_0.22.0_arm64.deb

# -------------------------------------------
# UTILS

function download() {
    url=$1
    output=$2
    wget $url --show-progress -O $output
}

function deb_install() {
    sudo gdebi -n $1
}

# -------------------------------------------

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
}

function setup_git {
    sudo apt install -y git
    ssh-keygen -t ed25519 -C "$GIT_EMAIL"
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
    echo
    cat ~/.ssh/id_ed25519.pub
    echo
    read -p "Copy paste the above key to github -> profile icon -> settings -> ssh keys, then press any key"
    echo "git setup complete!"
}

function install_packges() {
    sudo apt install -y keepass2
}

function install_freetube() {
    download $FREETUBE_URL freetube.deb
    deb_install freetube.deb
}

mkdir -p $WOZ_DIR
mkdir -p $TEMP_DIR
pushd $TEMP_DIR
# note: no mega as there's no arm binary
setup_network_share
# setup_git
# install_packges
# install_freetube
