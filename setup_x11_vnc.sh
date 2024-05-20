#!/bin/bash
sudo apt update
sudo apt install -y x11vnc git 
PASSWORD_SET=$1
PASSWORD=$2

# Set a password for x11vnc if provided
if [ "$PASSWORD_SET" = true ]; then
    mkdir -p ~/.vnc
    echo "$PASSWORD" | x11vnc -storepasswd stdin ~/.vnc/passwd
    X11VNC_OPTIONS="-rfbauth /home/$USER/.vnc/passwd"
else
    X11VNC_OPTIONS=""
fi

# Create x11vnc service
cat << EOF | sudo tee /etc/systemd/system/x11vnc.service
[Unit]
Description=Start x11vnc at startup.
After=multi-user.target

[Service]
Type=simple
ExecStart=/usr/bin/x11vnc -display :0 -forever -shared -auth guess $X11VNC_OPTIONS
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Enable and start x11vnc service
sudo systemctl enable x11vnc.service
sudo systemctl start x11vnc.service
