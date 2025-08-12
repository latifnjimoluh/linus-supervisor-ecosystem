#!/bin/bash
# 🧠 Script de configuration du DNS Maître - ${DNS_HOSTNAME} (${OS_VERSION})

echo "📦 Installation de BIND9..."
sudo apt update && sudo apt install bind9 bind9utils bind9-doc -y
sudo apt install curl -y

echo "📁 Création du répertoire des zones..."
sudo mkdir -p /etc/bind/zones
sudo chown bind:bind /etc/bind/zones

echo "🔧 Configuration des options globales dans /etc/bind/named.conf.options..."
sudo tee /etc/bind/named.conf.options > /dev/null <<EOF
options {
    directory "/var/cache/bind";

    allow-query { 127.0.0.1; ${ALLOWED_QUERY_SUBNET}; };
    recursion no;

    allow-transfer { ${SLAVE_IP}; };
    dnssec-validation auto;

    listen-on { 127.0.0.1; ${DNS_IP}; };
    listen-on-v6 { none; };
};
EOF

echo "📌 Définition des zones dans /etc/bind/named.conf.local..."
sudo tee /etc/bind/named.conf.local > /dev/null <<EOF
${ZONE_CONFIGS}
EOF

echo "🔓 Autorisation du trafic DNS depuis le slave..."
sudo ufw allow from ${SLAVE_IP} to any port 53 proto udp
sudo ufw allow from ${SLAVE_IP} to any port 53 proto tcp

echo "🚀 Redémarrage du service BIND9..."
sudo systemctl restart bind9
sudo systemctl enable bind9

echo "✅ Configuration du DNS Maître terminée."