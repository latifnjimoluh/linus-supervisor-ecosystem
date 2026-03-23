#!/bin/bash
# 🎯 Script de configuration client NFS pour montage du dossier partagé

echo "📦 Installation du client NFS..."
sudo apt update && sudo apt install -y nfs-common

echo "📁 Création du dossier local ${MOUNT_DIR}..."
sudo mkdir -p ${MOUNT_DIR}

echo "🔗 Montage du partage NFS depuis ${NFS_SERVER}:${SHARE_DIR}"
sudo mount ${NFS_SERVER}:${SHARE_DIR} ${MOUNT_DIR}

echo "🔒 Optionnel : ajout dans /etc/fstab pour montage permanent..."
echo "${NFS_SERVER}:${SHARE_DIR} ${MOUNT_DIR} nfs defaults 0 0" | sudo tee -a /etc/fstab

echo "✅ Client NFS configuré et monté."