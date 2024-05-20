#!/bin/bash

# Create tiger service
sudo bash -c 'cat <<EOT >> /etc/systemd/system/tightvnc.service
[Unit]
Description=Start TightVNC server at startup
After=syslog.target network.target

[Service]
Type=forking
User=ubuntu
PAMName=login
PIDFile=/home/ubuntu/.vnc/%H:1.pid
ExecStartPre=-/usr/bin/vncserver -kill :1 > /dev/null 2>&1
ExecStart=/usr/bin/vncserver :1
ExecStop=/usr/bin/vncserver -kill :1

[Install]
WantedBy=multi-user.target
EOT'

# Reload systemd, start and enable VNC service
sudo systemctl daemon-reload
sudo systemctl start tightvnc
sudo systemctl enable tightvnc
