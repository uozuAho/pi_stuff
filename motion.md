# Configure & run motion on a raspberry pi

# install
```sh
sudo apt-get install motion
sudo raspi-config  # -> enable camera
# reboot
# configure motion:
cp /etc/motion/motion.conf .
# does motion start without error?
sudo motion -c motion.conf
# press ctrl-c to exit
```

# configure
Change the following settings in `motion.conf`. Note that the setting names
depend on the version of motion. Check "Configuration Options-Listed
Alphabetically" in the [motion config docs](https://motion-project.github.io/motion_config.html).

```
target_dir /media/share/somedir
stream_localhost off
max_movie_time 1800
ffmpeg_output_movies on
```

The stream can be accessed via a browser: http://pi.ip.address:8081

# to do
- recording video to share not working. no errors in logs, no video files saved

# references
- [motion docs](https://motion-project.github.io/motion_config.html)

# alternatives
- [motioneyeos](https://github.com/ccrisan/motioneyeos/wiki)
    - this was very easy to set up. basically plug and play.
    - buggy. latest official stops recording after ~1h, latest dev can't save
      settings
    - [tutorial](https://pimylifeup.com/raspberry-pi-security-camera/)
    - [another tutorial](https://gndtovcc.home.blog/2020/04/17/install-motioneyeos-on-raspberry-pi-surveillance-camera-system/)
- [rpisurv](https://github.com/SvenVD/rpisurv)
    - haven't tried this
