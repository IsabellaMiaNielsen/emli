# Project in EMLI
The GitHub has been divided into two sections. The code on the raspberry pi (the camera) is under the "camera" folder. The code on the drone is under the "drone" folder. The metadata the drone uploads get uploaded under the "drone" folder in a folder called "photos" under the folders with the name of the date of when the pictures the metadata is describing was taken.

Some files within the camera folder are located elsewhere on the pi. The website folder is located at /var/www/html, the boot.sh file is located at /home/group7/bin/boot.sh, the camera daemon service, which starts on boot, is located under /etc/systemd/system/camera-daemon.service, the jail.local which is located under /etc/fail2ban/jail.local, and the sshd_config which is located under /etc/ssh/sshd_config, protecting against password logins through shh. The drone has been added as a root user, and therefore does not need ti give passwords for sudo commands. This is done through the sudoers file that is under the camera folder, but originally lies under /etc/sudoers. 

This project was developed by Isabella, Nikolas, and Rokas from group 07.
