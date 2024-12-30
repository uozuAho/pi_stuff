# Configure & run motion on a raspberry pi

Assumes a freshly installed OS. Verified on a pi zero W v1.

# install & check camera
```sh
sudo apt update
sudo apt install -y motion libcamera-v4l2 libcamera-tools
cp /etc/motion/motion.conf .
nano motion.conf
# comment out log_file
# before configuring further, check if the camera is working:
libcamerify motion -c motion.conf
# the console should indicate that the camera started
```

# position camera & configure motion detection
Change the following settings in `motion.conf`. See
[motion config docs](https://motion-project.github.io/motion_config.html) for
details.

```
target_dir = /some/dir/you/can/access   # images and movies will go here
stream_localhost off                    # allow remote streaming
webcontrol_localhost off                # allow remote web interface
# despeckle_filter                      # turn off despeckle
```

- run `libcamerify motion -c motion.conf`
- browse to http://pi.ip.address:8080 to see the live stream
- position the camera
- ctrl+c to exit motion
- run `libcamerify motion -s -c motion.conf`

The `-s` runs setup mode. The live stream now only shows detected motion. You
should be able to alter configuration values via the web interface. I wasn't
able to as the configuration option dropdown was empty. What the live stream
shows:

- black by default
- changed pixels in white
- numbers at the bottom:
    - D: number of changed pixels (use this to set thresholds)
    - L: labelled areas (if despeckle is enabled. labelled areas appear in blue)
    - N: noise setting (auto-tunes itself by default)

See the [setup mode guide](https://motion-project.github.io/4.6.0/motion_config.html#setup_mode)
for more details.

When done, update the config file:

```
daemon on        # runs in daemon mode (keeps running after ssh logout)
log_file  /some/path/you/can/access
```

Then run `libcamerify motion -c motion.conf`. Motion will start and enter daemon
mode. You can now logout.


# alternatives
- [motioneyeos](https://github.com/ccrisan/motioneyeos/wiki)
    - this was very easy to set up. basically plug and play.
    - buggy. latest official stops recording after ~1h, latest dev can't save
      settings
    - [tutorial](https://pimylifeup.com/raspberry-pi-security-camera/)
    - [another tutorial](https://gndtovcc.home.blog/2020/04/17/install-motioneyeos-on-raspberry-pi-surveillance-camera-system/)
- [rpisurv](https://github.com/SvenVD/rpisurv)
    - haven't tried this
