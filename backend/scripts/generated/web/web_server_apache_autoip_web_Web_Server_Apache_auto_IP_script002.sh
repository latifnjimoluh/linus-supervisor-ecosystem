#!/bin/bash
set -euo pipefail

DOMAIN_NAME="${DOMAIN_NAME:-example.com}"
WEB_ROOT="${WEB_ROOT:-/var/www/html}"
VM_NAME="${VM_NAME:-vm1}"

# Detect primary IP automatically
SERVER_IP=$(hostname -I | awk '{print $1}')

echo "🌐 Déploiement du serveur web Apache (demo.example.com)"

# Install packages
sudo apt update
sudo apt install -y apache2 curl

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
  <p>🌐 Vous êtes sur : <strong>demo.example.com</strong></p>
  <p>📍 IP : <strong>${SERVER_IP}</strong></p>
  <p>🧭 Cette page est hébergée sur la VM <strong>vm-demo</strong></p>
</body>
</html>
HTML

# Configure Apache virtual host
sudo tee /etc/apache2/sites-available/demo.example.com.conf > /dev/null <<APACHE
<VirtualHost *:80>
    ServerName demo.example.com
    DocumentRoot /var/www/demo
    ErrorLog ${APACHE_LOG_DIR}/demo.example.com.error.log
    CustomLog ${APACHE_LOG_DIR}/demo.example.com.access.log combined
</VirtualHost>
APACHE

sudo a2ensite demo.example.com.conf
sudo a2dissite 000-default.conf
sudo systemctl reload apache2
sudo systemctl enable apache2

# Firewall
sudo ufw allow OpenSSH
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw --force enable

# Record instance ID if provided
: "${INSTANCE_ID:?INSTANCE_ID is required}"
echo "INSTANCE_ID=abc123" | sudo tee /etc/instance-info.conf > /dev/null
echo "export INSTANCE_ID=abc123" | sudo tee /etc/profile.d/instance_id.sh > /dev/null
sudo chmod +x /etc/profile.d/instance_id.sh

# Log initialization
echo "$(date --iso-8601=seconds) - Initialized instance with ID: abc123" | sudo tee -a /var/log/init.log
