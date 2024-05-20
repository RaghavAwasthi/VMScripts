#!/bin/bash



# Create tiger service
cat << EOF | sudo tee /etc/systemd/system/tightvnc.service
[Unit]
Description=Start noVNC at startup.
After=multi-user.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/home/ubuntu
ExecStart=/usr/bin/vncviewer :1
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Enable and start tightvnc service
sudo systemctl enable tightvnc.service
sudo systemctl start tightvnc.service
