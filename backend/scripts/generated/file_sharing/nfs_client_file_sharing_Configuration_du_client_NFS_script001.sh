#!/bin/bash
# 🎯 Script de configuration client NFS pour montage du dossier partagé

echo "📦 Installation du client NFS..."
sudo apt update && sudo apt install -y nfs-common

echo "📁 Création du dossier local /mnt/nfs_share..."
sudo mkdir -p /mnt/nfs_share

echo "🔗 Montage du partage NFS depuis 192.168.10.10:/srv/nfs_share"
sudo mount 192.168.10.10:/srv/nfs_share /mnt/nfs_share

echo "🔒 Optionnel : ajout dans /etc/fstab pour montage permanent..."
echo "192.168.10.10:/srv/nfs_share /mnt/nfs_share nfs defaults 0 0" | sudo tee -a /etc/fstab

echo "✅ Client NFS configuré et monté."