#!/bin/bash



# Create tiger service
cat << EOF | sudo tee /etc/systemd/system/tightvnc.service
[Unit]
Description=Start noVNC at startup.
After=multi-user.target

[Service]
Type=simple
ExecStart=vncserver :1
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Enable and start tightvnc service
sudo systemctl enable tightvnc.service
sudo systemctl start tightvnc.service
