#!/bin/bash

echo "🚀 Déploiement du serveur API - api.camer.cm (192.168.24.17)"
APP_DIR="/opt/api"
VENVDIR="$APP_DIR/venv"
PROXY_IP="192.168.24.14"
API_USER="www-data"

# 1. Mise à jour système & dépendances
echo "📦 Installation des paquets requis..."
sudo apt update && sudo apt install -y python3-pip python3-venv ufw
sudo apt install curl -y

# 2. Création du dossier de l'application
echo "📁 Création du dossier $APP_DIR..."
sudo mkdir -p "$APP_DIR"
sudo chown -R $API_USER:$API_USER "$APP_DIR"

# 3. Création d'un environnement virtuel Python
echo "🐍 Initialisation de l’environnement virtuel..."
sudo -u $API_USER python3 -m venv "$VENVDIR"
source "$VENVDIR/bin/activate"

# 4. Installation de Flask et Gunicorn
echo "📦 Installation de Flask & Gunicorn..."
"$VENVDIR/bin/pip" install flask gunicorn

# 5. Création d’une application Flask minimaliste
echo "📝 Déploiement de l'application Flask (hello.py)"
sudo tee "$APP_DIR/app.py" > /dev/null <<EOF
from flask import Flask
app = Flask(__name__)

@app.route("/")
def home():
    return "✅ Bienvenue sur l’API interne Camer!"

if __name__ == "__main__":
    app.run()
EOF

# 6. Création du fichier WSGI
echo "🧩 Création du fichier WSGI (wsgi.py)"
sudo tee "$APP_DIR/wsgi.py" > /dev/null <<EOF
from app import app

if __name__ == "__main__":
    app.run()
EOF

# 7. Configuration du service systemd
echo "⚙️ Création du service systemd gunicorn"
sudo tee /etc/systemd/system/api-camer-cm.service > /dev/null <<EOF
[Unit]
Description=Service Gunicorn pour API Flask (api.camer.cm)
After=network.target

[Service]
User=$API_USER
Group=$API_USER
WorkingDirectory=$APP_DIR
Environment="PATH=$VENVDIR/bin"
ExecStart=$VENVDIR/bin/gunicorn --workers 3 --bind 0.0.0.0:5000 wsgi:app
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# 8. Démarrage du service
echo "🔄 Activation et lancement du service"
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable api-camer-cm
sudo systemctl start api-camer-cm
sudo systemctl status api-camer-cm --no-pager

# 9. Sécurisation avec UFW
echo "🛡️ Configuration du pare-feu (UFW)"
sudo ufw allow from $PROXY_IP proto tcp to any port 5000 comment "Autorise accès proxy vers API"
sudo ufw allow OpenSSH
sudo ufw --force enable
sudo ufw status verbose

# 10. Test local
echo "🔎 Test local sur http://127.0.0.1:5000"
curl -s http://127.0.0.1:5000 || echo "⚠️ API non accessible localement, vérifier les logs."

echo "✅ Déploiement terminé. L’API écoute sur le port 5000 (LAN uniquement)."