#!/bin/bash
echo "🔐 Initialisation sécurité serveur Linux..."

# 4️⃣ Mise à jour système
echo "🛠️ Mise à jour du système..."
apt-get update -qq && apt-get upgrade -y -qq

# 5️⃣ Installation fail2ban
echo "🛡️ Installation fail2ban..."
apt-get install -y -qq fail2ban
cat > /etc/fail2ban/jail.d/sshd.local <<EOF
[sshd]
enabled = true
port = 22
filter = sshd
logpath = /var/log/auth.log
maxretry = 5
bantime = 600
EOF
systemctl enable fail2ban
systemctl restart fail2ban

# 6️⃣ Pare-feu UFW (SSH uniquement)
echo "🔥 Configuration pare-feu UFW..."
apt-get install -y -qq ufw
ufw --force reset
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp comment "SSH"
ufw --force enable

# 7️⃣ Synchronisation de l'heure
echo "⏰ Synchronisation NTP..."
timedatectl set-ntp true
ntpdate ntp.ubuntu.com || true

# 1️⃣3️⃣ Journalisation systemd persistante
echo "📁 Activation des logs persistants..."
mkdir -p /var/log/journal
systemd-tmpfiles --create --prefix /var/log/journal
systemctl restart systemd-journald

# 1️⃣5️⃣ Activation rsyslog
echo "📊 Activation du service rsyslog..."
systemctl enable rsyslog
systemctl start rsyslog

echo "✅ Sécurité initiale appliquée avec succès."