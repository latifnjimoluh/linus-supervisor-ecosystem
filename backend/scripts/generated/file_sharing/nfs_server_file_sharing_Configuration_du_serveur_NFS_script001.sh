#!/bin/bash
# 🎯 Script de configuration du serveur NFS - nfs.camer.cm

echo "📦 Installation du serveur NFS..."
sudo apt update && sudo apt install -y nfs-kernel-server

echo "📁 Création du dossier partagé /srv/nfs_share..."
sudo mkdir -p /srv/nfs_share
sudo chown nobody:nogroup /srv/nfs_share
sudo chmod 777 /srv/nfs_share

echo "📝 Configuration du fichier /etc/exports..."
echo "/srv/nfs_share 192.168.10.0/24(rw,sync,no_subtree_check)" | sudo tee -a /etc/exports

echo "🔄 Redémarrage du service NFS..."
sudo systemctl restart nfs-kernel-server

echo "🔍 Vérification de l’export actif..."
sudo exportfs -v

echo "✅ Serveur NFS configuré avec succès."