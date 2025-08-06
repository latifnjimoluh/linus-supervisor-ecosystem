#!/bin/bash
set -e

: "${INSTANCE_ID:?INSTANCE_ID is required}"

# Save instance identifier
echo "INSTANCE_ID=$INSTANCE_ID" | sudo tee /etc/instance-info.conf > /dev/null
echo "export INSTANCE_ID=$INSTANCE_ID" | sudo tee /etc/profile.d/instance_id.sh > /dev/null
sudo chmod +x /etc/profile.d/instance_id.sh
export INSTANCE_ID=$INSTANCE_ID

# Update system and install security packages
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y curl htop ufw fail2ban unattended-upgrades

# Enable unattended security upgrades
sudo dpkg-reconfigure -f noninteractive unattended-upgrades

# Configure firewall
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow OpenSSH
sudo ufw allow 'Nginx Full'
sudo ufw --force enable

# Harden SSH
sudo sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl reload sshd

# Enable fail2ban
sudo systemctl enable --now fail2ban

# Log initialization
echo "$(date --iso-8601=seconds) - Initialized instance with ID: ${INSTANCE_ID}" | sudo tee -a /var/log/init.log
