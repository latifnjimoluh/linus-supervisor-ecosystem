#!/bin/bash
echo "🔐 Initialisation sécurité serveur Linux..."

# 📌 Instance ID injecté par Terraform
INSTANCE_ID="${instance_id}"

# 💾 Sauvegarde localement
echo "INSTANCE_ID=$INSTANCE_ID" | sudo tee /etc/instance-info.conf > /dev/null

# 🔧 Export pour tous les services système
echo "export INSTANCE_ID=$INSTANCE_ID" | sudo tee -a /etc/profile.d/instance_id.sh > /dev/null
chmod +x /etc/profile.d/instance_id.sh

# 📍 Log
echo "🆔 Instance ID injecté : $INSTANCE_ID"

# 1️⃣ Désactiver le login root SSH
echo "🔧 Désactivation du login root SSH..."
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
echo "PermitRootLogin no" >> /etc/ssh/sshd_config

# 2️⃣ Désactiver l'authentification par mot de passe
echo "🔧 Désactivation mot de passe SSH..."
sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
systemctl restart ssh