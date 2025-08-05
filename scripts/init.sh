#!/bin/bash
set -e

# ✅ Vérifie que INSTANCE_ID est bien présent dans l'environnement
if [ -z "$INSTANCE_ID" ]; then
  echo "❌ INSTANCE_ID non défini. Abandon du script."
  exit 1
fi

# 💾 Sauvegarde dans un fichier système
echo "INSTANCE_ID=$INSTANCE_ID" | sudo tee /etc/instance-info.conf > /dev/null

# 🔧 Rendre l'ID disponible pour tous les utilisateurs / services via le profile
echo "export INSTANCE_ID=$INSTANCE_ID" | sudo tee /etc/profile.d/instance_id.sh > /dev/null
sudo chmod +x /etc/profile.d/instance_id.sh

# 🔁 Ajoute la variable immédiatement à la session actuelle
export INSTANCE_ID=$INSTANCE_ID

# 📦 Installation de paquets utiles
sudo apt-get update -y
sudo apt-get install -y curl htop

# 📝 Log dans /var/log
echo "$(date --iso-8601=seconds) - Initialized instance with ID: ${INSTANCE_ID}" | sudo tee -a /var/log/init.log
