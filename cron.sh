# Just some random cron examples

# log cpu temperature to file every minute
*/1 * * * * echo "$(date) $(vcgencmd measure_temp)" >> /home/user/temps.log

# move local files to a network drive every minute
*/1 * * * * mv /home/user/files/* /media/some/drive/
