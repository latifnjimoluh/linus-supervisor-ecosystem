#!/bin/bash

echo "📦 Installation de BIND9 sur le DNS slave..."
sudo apt update && sudo apt install bind9 bind9utils bind9-doc -y
sudo apt install curl -y

echo "👤 Ajout de l'utilisateur courant au groupe bind..."
sudo usermod -aG bind "$USER"

echo "🔄 Activation du nouveau groupe pour cette session..."
newgrp bind <<EONG

echo "📁 Vérification du répertoire de cache BIND..."
sudo mkdir -p /var/cache/bind
sudo chown bind:bind /var/cache/bind
sudo chmod 770 /var/cache/bind

echo "⚙️ Configuration des options globales dans /etc/bind/named.conf.options..."
sudo tee /etc/bind/named.conf.options > /dev/null <<EOF
options {
    directory "/var/cache/bind";

    allow-query { 127.0.0.1; ${ALLOWED_QUERY_SUBNET}; };
    recursion no;

    dnssec-validation auto;

    listen-on { 127.0.0.1; ${SLAVE_IP}; };
    listen-on-v6 { none; };
};
EOF

echo "📌 Configuration des zones esclaves dans /etc/bind/named.conf.local..."
sudo tee /etc/bind/named.conf.local > /dev/null <<EOF
${ZONE_CONFIGS}
EOF

echo "🔓 Autorisation du trafic DNS depuis le maître (si UFW est actif)..."
sudo ufw allow from ${MASTER_IP} to any port 53 proto udp
sudo ufw allow from ${MASTER_IP} to any port 53 proto tcp

echo "🚀 Redémarrage de BIND9..."
sudo systemctl restart bind9
sudo systemctl enable bind9

echo "✅ Configuration terminée. Le slave attend les transferts du maître."

EONG