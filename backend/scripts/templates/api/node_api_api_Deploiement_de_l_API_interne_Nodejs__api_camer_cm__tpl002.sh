#!/bin/bash

SERVER_IP=$(hostname -I | awk '{print $1}')
echo "🚀 Déploiement du serveur API Node.js - ${DOMAIN_NAME} (${SERVER_IP})"
APP_DIR="${APP_DIR}"
PROXY_IP="${PROXY_IP}"
API_USER="${API_USER}"
SYSTEMD_SERVICE="${SYSTEMD_SERVICE}"

# ✅ Ensure the API user exists
if ! id -u "$API_USER" >/dev/null 2>&1; then
  sudo useradd -m -s /bin/bash "$API_USER"
fi

# 1. Mise à jour système & installation de Node.js
echo "📦 Installation de Node.js et des dépendances..."
sudo apt update && sudo apt install -y nodejs npm ufw curl

# 2. Création du dossier de l'application
echo "📁 Création du dossier $APP_DIR..."
sudo mkdir -p "$APP_DIR"
sudo chown -R $API_USER:$API_USER "$APP_DIR"
sudo chmod 775 "$APP_DIR"

# 3. Création de l'application Express minimale
sudo -u $API_USER tee "$APP_DIR/package.json" > /dev/null <<'PKG'
{
  "name": "camer-api",
  "version": "1.0.0",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^4.18.2"
  }
}
PKG

sudo -u $API_USER npm --prefix "$APP_DIR" install

sudo -u $API_USER tee "$APP_DIR/server.js" > /dev/null <<'JS'
const express = require('express');
const app = express();
app.get('/', (req, res) => res.send('✅ Bienvenue sur l\'API interne Camer!'));
const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`API listening on port ${port}`));
JS

# 4. Configuration du service systemd
sudo tee /etc/systemd/system/${SYSTEMD_SERVICE}.service > /dev/null <<'UNIT'
[Unit]
Description=Service Node.js pour API (${DOMAIN_NAME})
After=network.target

[Service]
User=$API_USER
Group=$API_USER
WorkingDirectory=$APP_DIR
ExecStart=/usr/bin/npm --prefix $APP_DIR start
Restart=on-failure
Environment=PORT=3000

[Install]
WantedBy=multi-user.target
UNIT

# 5. Démarrage du service
sudo systemctl daemon-reload
sudo systemctl enable ${SYSTEMD_SERVICE}
sudo systemctl start ${SYSTEMD_SERVICE}
sudo systemctl status ${SYSTEMD_SERVICE} --no-pager

# 6. Sécurisation avec UFW
sudo ufw allow from $PROXY_IP proto tcp to any port 3000 comment "Autorise accès proxy vers API"
sudo ufw allow OpenSSH
sudo ufw --force enable
sudo ufw status verbose

# 7. Test local
curl -s http://127.0.0.1:3000 || echo "⚠️ API non accessible localement, vérifier les logs."

echo "✅ Déploiement terminé. L’API Node.js écoute sur le port 3000 (LAN uniquement)."
