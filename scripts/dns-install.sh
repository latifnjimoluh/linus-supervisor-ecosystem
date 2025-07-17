#!/bin/bash

echo "🔧 Synchronisation de l'heure..."
timedatectl set-ntp true
ntpdate ntp.ubuntu.com || true

echo "🛠️ Installation du serveur DNS (bind9)..."
apt-get update -y
apt-get install -y bind9 bind9utils bind9-doc dnsutils

echo "✅ Installation terminée."
