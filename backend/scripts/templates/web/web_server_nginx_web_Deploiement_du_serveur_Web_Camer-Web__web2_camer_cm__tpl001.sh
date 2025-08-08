#!/bin/bash
set -e

echo "🌐 Déploiement du serveur Web Camer-Web (${DOMAIN_NAME})..."

# 1. Installation des paquets
echo "📦 Installation de nginx et apache2 (optionnel)..."
sudo apt update
sudo apt install curl -y
sudo apt install nginx apache2 -y

# 2. Préparation du répertoire web
echo "📁 Création du site web ${WEB_ROOT}"
sudo mkdir -p ${WEB_ROOT}

echo "📝 Création de la page d’accueil personnalisée..."
sudo tee ${WEB_ROOT}/index.html > /dev/null <<EOF
<!DOCTYPE html>
<html lang=\"fr\">
<head>
    <meta charset=\"UTF-8\">
    <title>Camer-Web</title>
</head>
<body style=\"font-family: sans-serif; text-align: center; margin-top: 100px;\">
    <h1>✅ Bienvenue sur Camer-Web</h1>
    <p>🌐 Vous êtes sur : <strong>${DOMAIN_NAME}</strong></p>
    <p>📍 IP : <strong>${IP_ADDRESS}</strong></p>
    <p>🧭 Cette page est hébergée sur la VM <strong>${VM_NAME}</strong></p>
</body>
</html>
EOF

# 3. Création du fichier NGINX vhost
echo "🔧 Configuration NGINX pour ${DOMAIN_NAME}..."
sudo tee /etc/nginx/sites-available/${DOMAIN_NAME} > /dev/null <<EOF
server {
    listen 80;
    server_name ${DOMAIN_NAME};

    access_log /var/log/nginx/${DOMAIN_NAME}.access.log;
    error_log /var/log/nginx/${DOMAIN_NAME}.error.log;

    root ${WEB_ROOT};
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

# 4. Activation du site et désactivation du défaut
sudo ln -s /etc/nginx/sites-available/${DOMAIN_NAME} /etc/nginx/sites-enabled/
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
echo "✅ Camer-Web est prêt. Teste http://${DOMAIN_NAME} depuis le reverse proxy ou le client interne."

: "\${INSTANCE_ID:?INSTANCE_ID is required}"

# Save instance identifier
echo "INSTANCE_ID=\${INSTANCE_ID}" | sudo tee /etc/instance-info.conf > /dev/null
echo "export INSTANCE_ID=\${INSTANCE_ID}" | sudo tee /etc/profile.d/instance_id.sh > /dev/null
sudo chmod +x /etc/profile.d/instance_id.sh
export INSTANCE_ID=\${INSTANCE_ID}

# Log initialization
echo "$(date --iso-8601=seconds) - Initialized instance with ID: \${INSTANCE_ID}" | sudo tee -a /var/log/init.log