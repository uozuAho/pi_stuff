# Raspberry pi setup

# SD card and first boot

On a linux/unix desktop machine:

```sh
# >> = user action
# ?? = info
# >> download raspberry pi os lite image: https://www.raspberrypi.org/downloads/raspbian/
# >> insert an SD card
# >> unmount any SD card partitions if they auto-mounted, for example:
sudo umount /media/user/boot
# >> write image to sd card:
sudo dd bs=1M if="~/Downloads/2017-04-10-raspbian-jessie-lite.img" of=/dev/mmcblk0
# >> ensure all data is written:
sync
# >> mount the boot partition (eject & reinsert sd card)
# ?? if you want to enable the serial port console:
# >> add the line `enable_uart=1` to the end of `/boot/config.txt`
# >> enable ssh:
touch /media/user/boot/ssh
# >> configure wifi:
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
# >> get the pi's IP address from your router
# >> ssh into the pi
ssh pi@192.168.1.XXX
password: (raspberry by default)
```

# extra bits
```sh
# enable camera
raspi-config  # -> enable camera
# set timezone
raspi-config  # -> localisation options
```

# OLD: WiFi & ssh setup via serial cable

- connect serial interface to pi, open terminal (minicom looks nicer):
    - `sudo minicom -s  # -s = first time setup, required once`
    - OR
    - `sudo miniterm.py /dev/ttyUSB0 115200`
- power on the pi (5V psu with at least 1A), wait for login prompt
    + MANY issues here, I think all to do with SD cards. Some hints:
        * ensure decent power supply on first boot, since SD partitions are
          rewritten - errors may leave SD unbootable. If this happens, re-image the
          SD and try again
        * verify image written to SD
        * sometimes disconnecting/reconnecting power on a frozen boot was enough
          to get to a login prompt
        * try different cards

Log in, then

    sudo su
    wpa_passphrase <your SSID> <your password> >> /etc/wpa_supplicant/wpa_supplicant.conf
    nano /etc/wpa_supplicant/wpa_supplicant.conf
    # remove the line showing your password!!
    # Ctrl-X (yes to save)
    exit
    sudo wpa_cli reconfigure
    # Wait a bit, then
    ifconfig

You should see your wlan0 interface with inet addr. ssh server is disabled by
default, so enable it:

    sudo raspi-config
    - Select Interfacing Options
    - Navigate to and select SSH
    - Choose Yes
    - Select Ok
    - Choose Finish

Now you can ssh into your pi! Time to throw away that serial interface.
