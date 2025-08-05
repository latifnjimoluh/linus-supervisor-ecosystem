#!/bin/bash
set -e

# Ensure the deployment injects an instance identifier
: "${INSTANCE_ID:?INSTANCE_ID is required}"

# 💾 Sauvegarde localement
echo "INSTANCE_ID=$INSTANCE_ID" | sudo tee /etc/instance-info.conf > /dev/null

# 🔧 Export pour tous les services système
echo "export INSTANCE_ID=$INSTANCE_ID" | sudo tee -a /etc/profile.d/instance_id.sh > /dev/null
chmod +x /etc/profile.d/instance_id.sh

apt-get update -y
apt-get install -y curl htop
echo "Initialized instance ${INSTANCE_ID}" >> /var/log/init.log
