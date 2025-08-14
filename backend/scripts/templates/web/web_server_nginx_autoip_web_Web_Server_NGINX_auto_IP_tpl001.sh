#!/bin/bash
set -euo pipefail

DOMAIN_NAME="${DOMAIN_NAME:-example.com}"
WEB_ROOT="${WEB_ROOT:-/var/www/html}"
VM_NAME="${VM_NAME:-vm1}"

# Detect primary IP automatically
SERVER_IP=$(hostname -I | awk '{print $1}')

echo "🌐 Déploiement du serveur web NGINX (${DOMAIN_NAME})"

# Install packages
sudo apt update
sudo apt install -y nginx curl

# Prepare web directory
sudo mkdir -p "$WEB_ROOT"

sudo tee "$WEB_ROOT/index.html" > /dev/null <<HTML
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <title>Camer-Web</title>
</head>
<body style="font-family: sans-serif; text-align: center; margin-top: 100px;">
  <h1>✅ Bienvenue sur Camer-Web</h1>
  <p>🌐 Vous êtes sur : <strong>${DOMAIN_NAME}</strong></p>
  <p>📍 IP : <strong>${SERVER_IP}</strong></p>
  <p>🧭 Cette page est hébergée sur la VM <strong>${VM_NAME}</strong></p>
</body>
</html>
HTML

# Configure nginx vhost
sudo tee /etc/nginx/sites-available/${DOMAIN_NAME} > /dev/null <<NGINX
server {
    listen 80;
    server_name ${DOMAIN_NAME};
    root ${WEB_ROOT};
    index index.html;
    access_log /var/log/nginx/${DOMAIN_NAME}.access.log;
    error_log /var/log/nginx/${DOMAIN_NAME}.error.log;
    location / {
        try_files \$uri \$uri/ =404;
    }
}
NGINX

sudo ln -sf /etc/nginx/sites-available/${DOMAIN_NAME} /etc/nginx/sites-enabled/${DOMAIN_NAME}
sudo rm -f /etc/nginx/sites-enabled/default

sudo systemctl restart nginx
sudo systemctl enable nginx

# Firewall
sudo ufw allow OpenSSH
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw --force enable

# Record instance ID if provided
: "${INSTANCE_ID:?INSTANCE_ID is required}"
echo "INSTANCE_ID=${INSTANCE_ID}" | sudo tee /etc/instance-info.conf > /dev/null
echo "export INSTANCE_ID=${INSTANCE_ID}" | sudo tee /etc/profile.d/instance_id.sh > /dev/null
sudo chmod +x /etc/profile.d/instance_id.sh

# Log initialization
echo "$(date --iso-8601=seconds) - Initialized instance with ID: ${INSTANCE_ID}" | sudo tee -a /var/log/init.log
