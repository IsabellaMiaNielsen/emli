# Project in EMLI
The GitHub has been divided into two sections. The code on the raspberry pi (the camera) is under the "camera" folder. The code on the drone is under the "drone" folder. The metadata the drone uploads get uploaded under the "drone" folder in a folder called "photos" under the folders with the name of the date of when the pictures the metadata is describing was taken.

Some files within the camera folder are located elsewhere on the pi. The website folder is located at /var/www/html, the boot.sh file is located at /home/group7/bin/boot.sh, the camera daemon service, which starts on boot, is located under /etc/systemd/system/camera-daemon.service, and the jail.local which is located under /etc/fail2ban/jail.local.

This project was developed by Isabella, Nikolas, and Rokas from group 07.
