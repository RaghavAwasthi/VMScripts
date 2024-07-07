#!/bin/bash

# Set up noVNC
cd /opt
sudo git clone https://github.com/novnc/noVNC.git
sudo git clone https://github.com/novnc/websockify.git noVNC/utils/websockify

# Ensure proper permissions for noVNC files
sudo chown -R www-data:www-data /opt/noVNC
sudo chmod -R 755 /opt/noVNC

# Create noVNC service
cat << EOF | sudo tee /etc/systemd/system/novnc.service
[Unit]
Description=Start noVNC at startup.
After=multi-user.target

[Service]
Type=simple
ExecStart=/opt/noVNC/utils/novnc_proxy --vnc localhost:5900 --listen 6080
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Enable and start noVNC service
sudo systemctl enable novnc.service
sudo systemctl start novnc.service
root@ip-172-31-44-32:~/VMScripts# cat setup_tight.sh 
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
