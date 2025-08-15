#!/bin/bash
set -euo pipefail

# 📁 Dossier de sortie personnalisable
MONITOR_DIR="${MONITOR_DIR:-/opt/monitoring}"
mkdir -p "$MONITOR_DIR"

# 📦 Créer le script de surveillance des services
cat <<'EOS' > "$MONITOR_DIR/services_status.sh"
#!/bin/bash
set -euo pipefail

# Répertoire cible (par défaut le dossier du script)
MONITOR_DIR="${MONITOR_DIR:-$(cd "$(dirname "$0")" && pwd)}"
mkdir -p "$MONITOR_DIR"

# 🔐 Charger l'INSTANCE_ID depuis /etc/instance-info.conf si présent
if [ -f /etc/instance-info.conf ]; then
  source /etc/instance-info.conf
fi

TIMESTAMP=$(date -Iseconds)
INSTANCE_ID="${INSTANCE_ID:-undefined}"

SERVICES=(
  sshd ufw fail2ban cron crond nginx apache2 mysql mariadb postgresql docker kubelet redis-server mongod vsftpd proftpd php-fpm
)

SERVICE_STATUS_JSON=""
for svc in "${SERVICES[@]}"; do
  if systemctl list-units --type=service --all | grep -q "$svc"; then
    ACTIVE=$(systemctl is-active "$svc" 2>/dev/null)
    ENABLED=$(systemctl is-enabled "$svc" 2>/dev/null)
    SERVICE_STATUS_JSON+="{\"name\":\"$svc\",\"active\":\"$ACTIVE\",\"enabled\":\"$ENABLED\"},"
  fi
done
SERVICE_STATUS_JSON="[${SERVICE_STATUS_JSON%,}]"

cat <<JSON > "$MONITOR_DIR/services_status.json"
{
  "timestamp": "${TIMESTAMP}",
  "instance_id": "${INSTANCE_ID}",
  "services": ${SERVICE_STATUS_JSON}
}
JSON
EOS

chmod +x "$MONITOR_DIR/services_status.sh"

# 🕔 Ajout au cron (évite les doublons)
grep -q "services_status.sh" /etc/crontab || echo "*/5 * * * * root $MONITOR_DIR/services_status.sh" >> /etc/crontab

