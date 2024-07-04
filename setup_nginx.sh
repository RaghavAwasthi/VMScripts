#!/bin/bash
sudo apt install -y nginx git openssl
# Generate a self-signed SSL certificate
# sudo mkdir -p /etc/nginx/ssl
# sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/selfsigned.key -out /etc/nginx/ssl/selfsigned.crt -subj "/CN=localhost"
# sudo openssl dhparam -out /etc/nginx/ssl/dhparam.pem 2048

# Set permissions for SSL files
# sudo chown root:www-data /etc/nginx/ssl/selfsigned.key /etc/nginx/ssl/selfsigned.crt /etc/nginx/ssl/dhparam.pem
# sudo chmod 640 /etc/nginx/ssl/selfsigned.key
# sudo chmod 644 /etc/nginx/ssl/selfsigned.crt
# sudo chmod 644 /etc/nginx/ssl/dhparam.pem

# # Create SSL configuration snippets for nginx
# sudo tee /etc/nginx/snippets/self-signed.conf > /dev/null <<EOF
# ssl_certificate /etc/nginx/ssl/selfsigned.crt;
# ssl_certificate_key /etc/nginx/ssl/selfsigned.key;
# EOF

# sudo tee /etc/nginx/snippets/ssl-params.conf > /dev/null <<EOF
# ssl_protocols TLSv1.2;
# ssl_prefer_server_ciphers on;
# ssl_ciphers "ECDHE-RSA-AES128-GCM-SHA256:HIGH:!aNULL:!MD5:!3DES";
# ssl_dhparam /etc/nginx/ssl/dhparam.pem;
# ssl_session_timeout 1d;
# ssl_session_cache shared:SSL:50m;
# ssl_stapling on;
# ssl_stapling_verify on;
# add_header Strict-Transport-Security "max-age=15768000" always;
# EOF

# Configure nginx
sudo tee /etc/nginx/sites-available/default > /dev/null <<EOF
server {
    listen 80;
    server_name _;


}

server {
    listen 80 ;
    server_name _;

    

    location / {
        root /opt/noVNC;
        index vnc.html;
        try_files \$uri \$uri/ =404;
    }

    location /websockify {
        proxy_pass http://localhost:6080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_set_header Host \$host;
    }
}
EOF

# Reload nginx to apply the new configuration
sudo systemctl reload nginx
