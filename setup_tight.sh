#!/bin/bash

# Create tiger service
cat << EOF | sudo tee /etc/systemd/system/tightvnc.service
[Unit]
Description=Start TightVNC server at startup
After=syslog.target network.target

[Service]
Type=forking
User=ubuntu
ExecStartPre=-/usr/bin/vncserver -kill :1 
ExecStart=/usr/bin/vncserver :1
ExecStop=/usr/bin/vncserver -kill :1

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd, start and enable VNC service
sudo systemctl daemon-reload
sudo systemctl start tightvnc
sudo systemctl enable tightvnc
