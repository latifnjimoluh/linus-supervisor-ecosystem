#!/bin/bash
# 🧠 Script de configuration du DNS Maître - dns1.camer.cm (Ubuntu 22.04)

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

    allow-query { 127.0.0.1; 192.168.0.0/16; };
    recursion no;

    allow-transfer { 192.168.24.20; };
    dnssec-validation auto;

    listen-on { 127.0.0.1; 192.168.24.10; };
    listen-on-v6 { none; };
};
EOF

echo "📌 Définition des zones dans /etc/bind/named.conf.local..."
sudo tee /etc/bind/named.conf.local > /dev/null <<EOF
zone "camer.cm" {
    type master;
    file "/etc/bind/zones/db.camer.cm";
    allow-transfer { 192.168.20.20; };
};

zone "bunec.cm" {
    type master;
    file "/etc/bind/zones/db.bunec.cm";
    allow-transfer { 192.168.20.20; };
};

zone "etatcivil.cm" {
    type master;
    file "/etc/bind/zones/db.etatcivil.cm";
    allow-transfer { 192.168.20.20; };
};

zone "civilstatus.cm" {
    type master;
    file "/etc/bind/zones/db.civilstatus.cm";
    allow-transfer { 192.168.20.20; };
};
EOF

echo "🔓 Autorisation du trafic DNS depuis le slave..."
sudo ufw allow from 192.168.24.20 to any port 53 proto udp
sudo ufw allow from 192.168.24.20 to any port 53 proto tcp

echo "🚀 Redémarrage du service BIND9..."
sudo systemctl restart bind9
sudo systemctl enable bind9

echo "✅ Configuration du DNS Maître terminée."