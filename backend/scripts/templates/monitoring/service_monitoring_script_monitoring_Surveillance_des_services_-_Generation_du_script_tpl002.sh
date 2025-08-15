#!/bin/bash

# 📁 Créer le dossier de monitoring s’il n’existe pas
mkdir -p /opt/monitoring

# 📦 Créer le script de surveillance des services
cat <<'EOS' > ${SERVICES_SCRIPT_PATH}
#!/bin/bash

# 🔐 Assurer la présence de l'INSTANCE_ID
if [ -f /etc/instance-info.conf ]; then
  source /etc/instance-info.conf
else
  uuid=$(command -v uuidgen >/dev/null 2>&1 && uuidgen || cat /proc/sys/kernel/random/uuid)
  echo "INSTANCE_ID=$uuid" > /etc/instance-info.conf
  INSTANCE_ID="$uuid"
fi

TIMESTAMP=$(date -Iseconds)
INSTANCE_ID="${INSTANCE_ID:-undefined}"

SERVICES=(
  sshd ufw fail2ban cron crond nginx apache2 mysql
  mariadb postgresql docker kubelet redis-server
  mongod vsftpd proftpd php-fpm
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

cat <<JSON > ${SERVICES_JSON_PATH}
{
  "timestamp": "${TIMESTAMP}",
  "instance_id": "${INSTANCE_ID}",
  "services": ${SERVICE_STATUS_JSON}
}
JSON
EOS

chown root:root ${SERVICES_JSON_PATH}
chmod 644 ${SERVICES_JSON_PATH}
chown root:root ${SERVICES_SCRIPT_PATH}
chmod +x ${SERVICES_SCRIPT_PATH}
