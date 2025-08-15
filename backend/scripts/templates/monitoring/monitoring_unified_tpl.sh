#!/bin/bash
set -euo pipefail

# 📁 Dossier de sortie personnalisable
MONITOR_DIR="${MONITOR_DIR:-/opt/monitoring}"
CRON_INTERVAL="${CRON_INTERVAL:-5}"
mkdir -p "$MONITOR_DIR"

# Ensure instance ID exists
if [ ! -f /etc/instance-info.conf ]; then
  uuid=$(command -v uuidgen >/dev/null 2>&1 && uuidgen || cat /proc/sys/kernel/random/uuid)
  echo "INSTANCE_ID=$uuid" > /etc/instance-info.conf
fi

# 📦 Créer le script de monitoring global
cat <<'EOS' > "$MONITOR_DIR/monitoring.sh"
#!/bin/bash
set -euo pipefail

MONITOR_DIR="${MONITOR_DIR:-$(cd "$(dirname "$0")" && pwd)}"
mkdir -p "$MONITOR_DIR"

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

# --- Surveillance système ---
HOSTNAME=$(hostname)
IP_ADDR=$(hostname -I | awk '{print $1}')
LOAD_AVG=$(cut -d ' ' -f1-3 /proc/loadavg)
MEM_TOTAL=$(grep MemTotal /proc/meminfo | awk '{print $2}')
MEM_AVAILABLE=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
DISK_TOTAL=$(df -B1 / | tail -1 | awk '{print $2}')
DISK_USED=$(df -B1 / | tail -1 | awk '{print $3}')
DISK_AVAIL=$(df -B1 / | tail -1 | awk '{print $4}')
IFACE=$(ip route get 1.1.1.1 | awk '{print $5; exit}')
RX_BYTES=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)
TX_BYTES=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)
OPEN_PORTS=$(ss -tuln | awk 'NR>1 {split($5,a,":"); print a[length(a)]}' | sort -n | uniq | paste -sd, -)
TOP_PROCESSES=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | tail -n 5 | awk '{printf "{\"pid\":%s,\"cmd\":\"%s\",\"cpu\":%s}",",", $1, $2, $3}')
TOP_PROCESSES="[${TOP_PROCESSES#,}]"

cat <<JSON > "$MONITOR_DIR/status.json"
{
  "timestamp": "$TIMESTAMP",
  "instance_id": "$INSTANCE_ID",
  "hostname": "$HOSTNAME",
  "ip_address": "$IP_ADDR",
  "load_average": "$LOAD_AVG",
  "memory": {
    "total_kb": $MEM_TOTAL,
    "available_kb": $MEM_AVAILABLE
  },
  "disk": {
    "total_bytes": $DISK_TOTAL,
    "used_bytes": $DISK_USED,
    "available_bytes": $DISK_AVAIL
  },
  "network": {
    "interface": "$IFACE",
    "rx_bytes": $RX_BYTES,
    "tx_bytes": $TX_BYTES
  },
  "open_ports": [$OPEN_PORTS],
  "top_processes": $TOP_PROCESSES
}
JSON

# --- Surveillance des services ---
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
  "timestamp": "$TIMESTAMP",
  "instance_id": "$INSTANCE_ID",
  "services": $SERVICE_STATUS_JSON
}
JSON

# --- Logs système ---
# Erreurs système récentes
ERROR_LINES=$(journalctl -p 3 -n 50 --no-pager 2>/dev/null | sed 's/"/\\"/g')
ERROR_JSON=""
while IFS= read -r line; do
  [ -z "$line" ] && continue
  ERROR_JSON+="\"$line\"," 
done <<< "$ERROR_LINES"
ERROR_JSON="[${ERROR_JSON%,}]"

# Connexions et actions (auth.log ou journalctl)
AUTH_LINES=""
if [ -f /var/log/auth.log ]; then
  AUTH_LINES=$(grep -E 'session opened|session closed|sudo' /var/log/auth.log | tail -n 50 | sed 's/"/\\"/g')
else
  AUTH_LINES=$(journalctl -u sshd -u sudo -n 50 --no-pager 2>/dev/null | sed 's/"/\\"/g')
fi
AUTH_JSON=""
while IFS= read -r line; do
  [ -z "$line" ] && continue
  AUTH_JSON+="\"$line\"," 
done <<< "$AUTH_LINES"
AUTH_JSON="[${AUTH_JSON%,}]"

cat <<JSON > "$MONITOR_DIR/logs_status.json"
{
  "timestamp": "$TIMESTAMP",
  "instance_id": "$INSTANCE_ID",
  "errors": $ERROR_JSON,
  "system_events": $AUTH_JSON
}
JSON
EOS

chmod +x "$MONITOR_DIR/monitoring.sh"

# 🕔 Ajout au cron (évite les doublons)
grep -q "monitoring.sh" /etc/crontab || echo "*/${CRON_INTERVAL} * * * * root $MONITOR_DIR/monitoring.sh" >> /etc/crontab
