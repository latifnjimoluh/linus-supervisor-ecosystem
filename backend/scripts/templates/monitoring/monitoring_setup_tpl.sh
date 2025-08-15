#!/bin/bash
set -euo pipefail

# Ensure monitoring directory exists with correct permissions
MONITOR_DIR="${MONITOR_DIR:-/opt/monitoring}"
CRON_USER="${CRON_USER:-nexus}"
sudo mkdir -p "$MONITOR_DIR"
sudo chown -R "$CRON_USER":"$CRON_USER" "$MONITOR_DIR"
sudo chmod 775 "$MONITOR_DIR"

# Ensure instance ID file exists
if [ ! -f /etc/instance-info.conf ]; then
  uuid=$(command -v uuidgen >/dev/null 2>&1 && uuidgen || cat /proc/sys/kernel/random/uuid)
  echo "INSTANCE_ID=$uuid" | sudo tee /etc/instance-info.conf >/dev/null
fi

# Paths
STATUS_SCRIPT_PATH="${STATUS_SCRIPT_PATH:-$MONITOR_DIR/status.sh}"
SERVICES_SCRIPT_PATH="${SERVICES_SCRIPT_PATH:-$MONITOR_DIR/services_status.sh}"
LOGS_SCRIPT_PATH="${LOGS_SCRIPT_PATH:-$MONITOR_DIR/logs.sh}"

# --- system status script ---
cat <<'EOS' > "$STATUS_SCRIPT_PATH"
#!/bin/bash
set -euo pipefail
MONITOR_DIR="${MONITOR_DIR:-$(cd "$(dirname "$0")" && pwd)}"
mkdir -p "$MONITOR_DIR"

if [ -f /etc/instance-info.conf ]; then
  source /etc/instance-info.conf
else
  uuid=$(command -v uuidgen >/dev/null 2>&1 && uuidgen || cat /proc/sys/kernel/random/uuid)
  echo "INSTANCE_ID=$uuid" > /etc/instance-info.conf
  INSTANCE_ID="$uuid"
fi

TIMESTAMP=$(date -Iseconds)
INSTANCE_ID="${INSTANCE_ID:-undefined}"
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
TOP_PROCESSES="[${TOP_PROCESSES%,}]"

cat <<JSON > "$MONITOR_DIR/status.json"
{
  "timestamp": "${TIMESTAMP}",
  "instance_id": "${INSTANCE_ID}",
  "hostname": "${HOSTNAME}",
  "ip_address": "${IP_ADDR}",
  "load_average": "${LOAD_AVG}",
  "memory": {
    "total_kb": ${MEM_TOTAL},
    "available_kb": ${MEM_AVAILABLE}
  },
  "disk": {
    "total_bytes": ${DISK_TOTAL},
    "used_bytes": ${DISK_USED},
    "available_bytes": ${DISK_AVAIL}
  },
  "network": {
    "interface": "${IFACE}",
    "rx_bytes": ${RX_BYTES},
    "tx_bytes": ${TX_BYTES}
  },
  "open_ports": [${OPEN_PORTS}],
  "top_processes": ${TOP_PROCESSES}
}
JSON
EOS
chmod +x "$STATUS_SCRIPT_PATH"

# --- services status script ---
cat <<'EOS' > "$SERVICES_SCRIPT_PATH"
#!/bin/bash
set -euo pipefail
MONITOR_DIR="${MONITOR_DIR:-$(cd "$(dirname "$0")" && pwd)}"
mkdir -p "$MONITOR_DIR"

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
chmod +x "$SERVICES_SCRIPT_PATH"

# --- important logs script ---
cat <<'EOS' > "$LOGS_SCRIPT_PATH"
#!/bin/bash
set -euo pipefail
MONITOR_DIR="${MONITOR_DIR:-$(cd "$(dirname "$0")" && pwd)}"
mkdir -p "$MONITOR_DIR"

if [ -f /etc/instance-info.conf ]; then
  source /etc/instance-info.conf
else
  uuid=$(command -v uuidgen >/dev/null 2>&1 && uuidgen || cat /proc/sys/kernel/random/uuid)
  echo "INSTANCE_ID=$uuid" > /etc/instance-info.conf
  INSTANCE_ID="$uuid"
fi

TIMESTAMP=$(date -Iseconds)
INSTANCE_ID="${INSTANCE_ID:-undefined}"
LOG_LINES=$(journalctl -p 3 -n 50 --no-pager 2>/dev/null | sed 's/"/\\"/g')
LOG_JSON=""
while IFS= read -r line; do
  [ -z "$line" ] && continue
  LOG_JSON+="\"$line\"," 
done <<< "$LOG_LINES"
LOG_JSON="[${LOG_JSON%,}]"

cat <<JSON > "$MONITOR_DIR/logs_status.json"
{
  "timestamp": "${TIMESTAMP}",
  "instance_id": "${INSTANCE_ID}",
  "logs": ${LOG_JSON}
}
JSON
EOS
chmod +x "$LOGS_SCRIPT_PATH"

# --- configure cron jobs ---
STATUS_CRON_EXPR="${STATUS_CRON_EXPR:-*/1 * * * *}"
SERVICES_CRON_EXPR="${SERVICES_CRON_EXPR:-*/1 * * * *}"
LOGS_CRON_EXPR="${LOGS_CRON_EXPR:-*/1 * * * *}"
MARK_STATUS="# MONITORING_STATUS_CRON"
MARK_SERVICES="# MONITORING_SERVICES_CRON"
MARK_LOGS="# MONITORING_LOGS_CRON"

crontab_get() { crontab -u "$CRON_USER" -l 2>/dev/null || true; }
crontab_set() { crontab -u "$CRON_USER" -; }
add_cron_once() {
  local expr="$1" cmd="$2" mark="$3"
  local current
  current="$(crontab_get)"
  if ! echo "$current" | grep -Fq "$mark"; then
    { echo "$current" | grep -Fv "$mark"; echo "$expr $cmd $mark"; } | crontab_set
  fi
}

add_cron_once "$STATUS_CRON_EXPR" "bash $STATUS_SCRIPT_PATH >$MONITOR_DIR/status.log 2>&1" "$MARK_STATUS"
add_cron_once "$SERVICES_CRON_EXPR" "bash $SERVICES_SCRIPT_PATH >$MONITOR_DIR/services_status.log 2>&1" "$MARK_SERVICES"
add_cron_once "$LOGS_CRON_EXPR" "bash $LOGS_SCRIPT_PATH >$MONITOR_DIR/logs_status.log 2>&1" "$MARK_LOGS"

# run once immediately
bash "$STATUS_SCRIPT_PATH" || true
bash "$SERVICES_SCRIPT_PATH" || true
bash "$LOGS_SCRIPT_PATH" || true

# ensure cron service is enabled
if command -v systemctl >/dev/null 2>&1; then
  systemctl enable --now cron 2>/dev/null || systemctl enable --now crond 2>/dev/null || true
fi

exit 0
