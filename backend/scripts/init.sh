#!/bin/bash
set -e


echo "🌐 Déploiement du serveur Web Camer-Web (web2.camer.cm)..."

# 1. Installation des paquets
echo "📦 Installation de nginx et apache2 (optionnel)..."
sudo apt update
sudo apt install curl -y
sudo apt install nginx apache2 -y

# 2. Préparation du répertoire web
echo "📁 Création du site web /var/www/web2.camer.cm"
sudo mkdir -p /var/www/web2.camer.cm

echo "📝 Création de la page d’accueil personnalisée..."
sudo tee /var/www/web2.camer.cm/index.html > /dev/null <<EOF
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Camer-Web</title>
</head>
<body style="font-family: sans-serif; text-align: center; margin-top: 100px;">
    <h1>✅ Bienvenue sur Camer-Web</h1>
    <p>🌐 Vous êtes sur : <strong>web2.camer.cm</strong></p>
    <p>📍 IP : <strong>192.168.20.21</strong></p>
    <p>🧭 Cette page est hébergée sur la VM <strong>Camer-Web</strong></p>
</body>
</html>
EOF

# 3. Création du fichier NGINX vhost
echo "🔧 Configuration NGINX pour web2.camer.cm..."
sudo tee /etc/nginx/sites-available/web2.camer.cm > /dev/null <<EOF
server {
    listen 80;
    server_name web2.camer.cm;

    access_log /var/log/nginx/web2.camer.cm.access.log;
    error_log /var/log/nginx/web2.camer.cm.error.log;

    root /var/www/web2.camer.cm;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

# 4. Activation du site et désactivation du défaut
sudo ln -s /etc/nginx/sites-available/web2.camer.cm /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default

# 5. Redémarrage des services
echo "🚀 Redémarrage de NGINX..."
sudo systemctl restart nginx
sudo systemctl enable nginx

# 6. Pare-feu
echo "🛡️ Configuration UFW pour NGINX..."
sudo ufw allow OpenSSH
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw --force enable

echo
echo "✅ Camer-Web est prêt. Teste http://web2.camer.cm depuis le reverse proxy ou le client interne."

: "${INSTANCE_ID:?INSTANCE_ID is required}"

# Save instance identifier
echo "INSTANCE_ID=$INSTANCE_ID" | sudo tee /etc/instance-info.conf > /dev/null
echo "export INSTANCE_ID=$INSTANCE_ID" | sudo tee /etc/profile.d/instance_id.sh > /dev/null
sudo chmod +x /etc/profile.d/instance_id.sh
export INSTANCE_ID=$INSTANCE_ID

# Log initialization
echo "$(date --iso-8601=seconds) - Initialized instance with ID: ${INSTANCE_ID}" | sudo tee -a /var/log/init.log
