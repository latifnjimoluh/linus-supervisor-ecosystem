#!/bin/bash
# 🎯 Script de configuration du serveur NFS - nfs.camer.cm

echo "📦 Installation du serveur NFS..."
sudo apt update && sudo apt install -y nfs-kernel-server

echo "📁 Création du dossier partagé ${SHARE_DIR}..."
sudo mkdir -p ${SHARE_DIR}
sudo chown nobody:nogroup ${SHARE_DIR}
sudo chmod 777 ${SHARE_DIR}

echo "📝 Configuration du fichier /etc/exports..."
echo "${SHARE_DIR} ${CLIENT_SUBNET}(rw,sync,no_subtree_check)" | sudo tee -a /etc/exports

echo "🔄 Redémarrage du service NFS..."
sudo systemctl restart nfs-kernel-server

echo "🔍 Vérification de l’export actif..."
sudo exportfs -v

echo "✅ Serveur NFS configuré avec succès."