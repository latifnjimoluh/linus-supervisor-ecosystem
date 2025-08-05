#!/bin/bash
set -e

# Instance identifier must be injected during deployment
: "${INSTANCE_ID:?INSTANCE_ID is required}"

apt-get update -y
apt-get install -y nginx
ufw allow 'Nginx HTTP'
systemctl enable --now nginx
echo "$(date --iso-8601=seconds) [${INSTANCE_ID}] Nginx installed" >> /var/log/setup_nginx.log
