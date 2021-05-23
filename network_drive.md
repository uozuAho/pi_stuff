# Connect a raspberry pi to a network drive

```sh
sudo apt install samba samba-common-bin smbclient cifs-utils
sudo mkdir /media/share
sudo chown pi /media/share
sudo chgrp pi /media/share
id -u pi  # prints user id
id -g pi  # prints group id
sudo nano /etc/fstab
# enter the following, filling in uid, gid (from above), username, password:
# my network share
# //192.168.1.100/share /media/share cifs defaults,rw,uid=,gid=,username=,password=,vers=2.0 0 0
```
