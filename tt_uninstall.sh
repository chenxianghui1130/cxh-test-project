#!/bin/bash
systemctl stop tt5server
systemctl disable tt5server
rm -f /usr/bin/tt5srv
rm -f /lib/systemd/system/tt5server.service
rm -rf /etc/teamtalk
rm -rf /var/log/teamtalk
userdel teamtalk
rm -rf /home/teamtalk

