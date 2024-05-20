#!/bin/bash

# Update and install necessary packages
sudo apt update
sudo apt install -y xfce4 xfce4-goodies tightvncserver git python3-websockify

# Configure VNC server
vncserver :1
vncserver -kill :1

# Backup and edit xstartup file
mv ~/.vnc/xstartup ~/.vnc/xstartup.bak
cat <<EOT >> ~/.vnc/xstartup
#!/bin/bash
xrdb \$HOME/.Xresources
startxfce4 &
EOT

chmod +x ~/.vnc/xstartup

# Start VNC server again
vncserver :1

# Install noVNC
git clone https://github.com/novnc/noVNC.git ~/noVNC
cd ~/noVNC
git submodule update --init --recursive

# Start noVNC server
./utils/novnc_proxy --vnc localhost:5901 --listen 6080 &

# Create a systemd service for noVNC
sudo bash -c 'cat <<EOT >> /etc/systemd/system/novnc.service
[Unit]
Description=noVNC Service
After=network.target

[Service]
Type=simple
User=ubuntu
ExecStart=/home/ubuntu/noVNC/utils/novnc_proxy --vnc localhost:5901 --listen 6080
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOT'

# Reload systemd, start and enable noVNC service
sudo systemctl daemon-reload
sudo systemctl start novnc
sudo systemctl enable novnc

# Print the access URL
PUBLIC_DNS=$(curl -s http://169.254.169.254/latest/meta-data/public-hostname)
echo "You can access noVNC at: http://$PUBLIC_DNS:6080/vnc.html"
