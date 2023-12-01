# Raspberry pi setup

# SD card and first boot

Use [Raspberry Pi Imager](https://www.raspberrypi.com/software/), or follow the steps below.
Last time I tried the steps below, I couldn't get my password to work.

On a linux/unix desktop machine:

```sh
# >> = user action
# ?? = info
# >> download raspberry pi os lite image: https://www.raspberrypi.org/downloads/raspbian/
# >> insert an SD card
# >> unmount any SD card partitions if they auto-mounted, for example:
sudo umount /media/<username>/boot
# >> write image to sd card, for example:
sudo dd bs=1M if="~/Downloads/2017-04-10-raspbian-jessie-lite.img" of=/dev/mmcblk0
# >> ensure all data is written:
sync
# >> mount the boot partition (eject & reinsert sd card)
# ?? if you want to enable the serial port console:
# >> add the line `enable_uart=1` to the end of `/boot/config.txt`
# >> enable ssh:
touch /media/<username>/boot/ssh
# >> set up a user + password:
openssl passwd -6
# >> this will output an encrypted password
echo <your pi username>:<encrypted password> > /media/<username>/boot/userconf.txt
# >> configure wifi:
# NOTE: this probably doesn't work any more. See https://www.raspberrypi.com/documentation/computers/configuration.html#connect-to-a-wireless-network
cat << EOF > /media/user/boot/wpa_supplicant.conf
country=AU
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
network={
    ssid="MyWiFiNetwork"
    psk="aVeryStrongPassword"
    key_mgmt=WPA-PSK
}
EOF
# >> unmount the sd card partitions, remove, and insert into the pi
# ?? note that the sd card partitions will be resized to fill the SD card on first boot
# >> get the pi's IP address:
ping raspberrypi.local
# >> or from your router; more methods here: https://www.raspberrypi.com/documentation/computers/remote-access.html#resolving-raspberrypi-local-with-mdns
# >> ssh into the pi
ssh <your pi username>@192.168.1.XXX
```

# extra bits
```sh
# enable camera
raspi-config  # -> enable camera
# set timezone
raspi-config  # -> localisation options
# git stuff
sudo apt-get install git
ssh-keygen -t ed25519 -C "your_email@example.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
# copy output, goto github -> user icon -> settings -> SSH .. -> add key
# get my pi repos
git clone git@github.com:uozuAho/pcconfig.git
git clone git@github.com:uozuAho/pi_stuff.git
```

# troubleshooting
- nothing happens when you power on the pi
    + MANY issues here, I think all to do with SD cards. Some hints:
        * ensure decent power supply on first boot, since SD partitions are
          rewritten - errors may leave SD unbootable. If this happens, re-image the
          SD and try again
        * verify image written to SD before using it with pi
        * sometimes disconnecting/reconnecting power on a frozen boot was enough
          to get to a login prompt
        * try different SD cards
