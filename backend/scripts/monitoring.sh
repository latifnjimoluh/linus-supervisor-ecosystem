#!/bin/bash
set -euo pipefail

# 📁 Dossier de sortie personnalisable
MONITOR_DIR="${MONITOR_DIR:-/opt/monitoring}"
CRON_INTERVAL="${CRON_INTERVAL:-5}"
mkdir -p "$MONITOR_DIR"

# 🔧 Dépendance : jq (installe si absent et si root)
if ! command -v jq >/dev/null 2>&1; then
  if [ "$(id -u)" -eq 0 ] && command -v apt-get >/dev/null 2>&1; then
    apt-get update -y && apt-get install -y jq
  else
    echo "⚠️ jq n'est pas installé et ne peut pas être installé automatiquement. JSON généré risquera d'être invalide."
  fi
fi

# 🆔 Ensure instance ID exists
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
  # shellcheck source=/dev/null
  source /etc/instance-info.conf
else
  uuid=$(command -v uuidgen >/dev/null 2>&1 && uuidgen || cat /proc/sys/kernel/random/uuid)
  echo "INSTANCE_ID=$uuid" > /etc/instance-info.conf
  INSTANCE_ID="$uuid"
fi

TIMESTAMP=$(date -Iseconds)
INSTANCE_ID="${INSTANCE_ID:-undefined}"

# --- Collecte bas niveau robuste ---
HOSTNAME=$(hostname 2>/dev/null || echo "unknown")
IP_ADDR=$(hostname -I 2>/dev/null | awk '{print $1}' || true)
IP_ADDR=${IP_ADDR:-"0.0.0.0"}
LOAD_AVG=$(awk '{print $1" "$2" "$3}' /proc/loadavg 2>/dev/null || echo "0.00 0.00 0.00")
MEM_TOTAL=$(grep -E '^MemTotal:' /proc/meminfo 2>/dev/null | awk '{print $2}' || echo 0)
MEM_AVAILABLE=$(grep -E '^MemAvailable:' /proc/meminfo 2>/dev/null | awk '{print $2}' || echo 0)
DISK_TOTAL=$(df -B1 / 2>/dev/null | tail -1 | awk '{print $2}' || echo 0)
DISK_USED=$(df -B1 / 2>/dev/null | tail -1 | awk '{print $3}' || echo 0)
DISK_AVAIL=$(df -B1 / 2>/dev/null | tail -1 | awk '{print $4}' || echo 0)

# Interface réseau par défaut (fallback à eth0 sinon)
IFACE=$(ip route 2>/dev/null | awk '/default/ {print $5; exit}')
IFACE=${IFACE:-eth0}
RX_BYTES=$(cat "/sys/class/net/$IFACE/statistics/rx_bytes" 2>/dev/null || echo 0)
TX_BYTES=$(cat "/sys/class/net/$IFACE/statistics/tx_bytes" 2>/dev/null || echo 0)

# --- Ports ouverts (liste de nombres) ---
PORTS_CSV=$(ss -tuln 2>/dev/null | awk 'NR>1 {split($5,a,":"); p=a[length(a)]; if(p ~ /^[0-9]+$/) print p}' | sort -n | uniq | paste -sd, - || true)
PORTS_JSON="[]"
if [ -n "${PORTS_CSV:-}" ]; then
  PORTS_JSON=$(printf '[%s]' "$PORTS_CSV")
fi

# --- Top processus (pid, cmd, cpu) : tableau JSON propre ---
TOP_LINES=$(
  ps -eo pid,comm,%cpu --no-headers --sort=-%cpu 2>/dev/null | head -n 5 | awk '{
    pid=$1; cmd=$2; cpu=$3;
    # Si des champs sont vides, on les ignore
    if (pid != "" && cmd != "" && cpu != "") {
      printf("{\"pid\":%d,\"cmd\":\"%s\",\"cpu\":%.2f}\n", pid, cmd, cpu);
    }
  }' | paste -sd, -
)
if [ -n "${TOP_LINES:-}" ]; then
  TOP_JSON=$(printf '[%s]' "$TOP_LINES")
else
  TOP_JSON='[]'
fi

# --- Construction status.json avec jq (écriture atomique + validation) ---
STATUS_TMP="$MONITOR_DIR/.status.json.tmp"
STATUS_DST="$MONITOR_DIR/status.json"
if command -v jq >/dev/null 2>&1; then
  jq -n \
    --arg timestamp "$TIMESTAMP" \
    --arg instance_id "$INSTANCE_ID" \
    --arg hostname "$HOSTNAME" \
    --arg ip_address "$IP_ADDR" \
    --arg loadavg "$LOAD_AVG" \
    --argjson mem_total "${MEM_TOTAL:-0}" \
    --argjson mem_avail "${MEM_AVAILABLE:-0}" \
    --argjson disk_total "${DISK_TOTAL:-0}" \
    --argjson disk_used "${DISK_USED:-0}" \
    --argjson disk_avail "${DISK_AVAIL:-0}" \
    --arg iface "$IFACE" \
    --argjson rx_bytes "${RX_BYTES:-0}" \
    --argjson tx_bytes "${TX_BYTES:-0}" \
    --arg ports "$PORTS_JSON" \
    --arg top_list "$TOP_JSON" \
    '
    {
      timestamp: $timestamp,
      instance_id: $instance_id,
      hostname: $hostname,
      ip_address: $ip_address,
      load_average: $loadavg,
      memory: { total_kb: $mem_total, available_kb: $mem_avail },
      disk: { total_bytes: $disk_total, used_bytes: $disk_used, available_bytes: $disk_avail },
      network: { interface: $iface, rx_bytes: $rx_bytes, tx_bytes: $tx_bytes },
      open_ports: ($ports | fromjson),
      top_processes: ($top_list | fromjson)
    }
    ' > "$STATUS_TMP"
  # Valide et commit
  jq empty "$STATUS_TMP" && mv -f "$STATUS_TMP" "$STATUS_DST"
else
  # Fallback minimal sans jq (moins sûr)
  cat > "$STATUS_DST" <<JSON
{
  "timestamp": "$TIMESTAMP",
  "instance_id": "$INSTANCE_ID",
  "hostname": "$HOSTNAME",
  "ip_address": "$IP_ADDR",
  "load_average": "$LOAD_AVG",
  "memory": { "total_kb": $MEM_TOTAL, "available_kb": $MEM_AVAILABLE },
  "disk": { "total_bytes": $DISK_TOTAL, "used_bytes": $DISK_USED, "available_bytes": $DISK_AVAIL },
  "network": { "interface": "$IFACE", "rx_bytes": $RX_BYTES, "tx_bytes": $TX_BYTES },
  "open_ports": $PORTS_JSON,
  "top_processes": $TOP_JSON
}
JSON
fi

# --- Surveillance des services ---
SERVICES=(
  sshd ufw fail2ban cron crond nginx apache2 mysql mariadb postgresql docker kubelet redis-server mongod vsftpd proftpd php-fpm
)
SERVICE_STATUS=()
for svc in "${SERVICES[@]}"; do
  if systemctl list-unit-files --type=service --all 2>/dev/null | awk '{print $1}' | grep -qx "${svc}.service"; then
    ACTIVE=$(systemctl is-active "$svc" 2>/dev/null || echo "unknown")
    ENABLED=$(systemctl is-enabled "$svc" 2>/dev/null || echo "unknown")
    SERVICE_STATUS+=( "{\"name\":\"$svc\",\"active\":\"$ACTIVE\",\"enabled\":\"$ENABLED\"}" )
  fi
done
SERVICES_JSON=$(printf "%s" "$(printf "%s," "${SERVICE_STATUS[@]:-}" | sed 's/,$//')")
[ -z "$SERVICES_JSON" ] && SERVICES_JSON=""

SERVICES_TMP="$MONITOR_DIR/.services_status.json.tmp"
cat > "$SERVICES_TMP" <<JSON
{
  "timestamp": "$TIMESTAMP",
  "instance_id": "$INSTANCE_ID",
  "services": [ $SERVICES_JSON ]
}
JSON
# Valider si jq dispo
if command -v jq >/dev/null 2>&1; then
  jq empty "$SERVICES_TMP" && mv -f "$SERVICES_TMP" "$MONITOR_DIR/services_status.json" || rm -f "$SERVICES_TMP"
else
  mv -f "$SERVICES_TMP" "$MONITOR_DIR/services_status.json"
fi

# --- Logs système (erreurs & événements) ---
# Erreurs système (priorité >= err)
ERROR_LINES=$(journalctl -p 3 -n 50 --no-pager 2>/dev/null || true)
AUTH_LINES=""
if [ -f /var/log/auth.log ]; then
  AUTH_LINES=$(grep -E 'session opened|session closed|sudo' /var/log/auth.log | tail -n 50 || true)
else
  AUTH_LINES=$(journalctl -u sshd -u sudo -n 50 --no-pager 2>/dev/null || true)
fi

LOGS_TMP="$MONITOR_DIR/.logs_status.json.tmp"
if command -v jq >/dev/null 2>&1; then
  # Construire des tableaux de chaînes en toute sécurité
  ERR_JSON=$(printf "%s" "$ERROR_LINES" | jq -Rsc 'split("\n")[:-1]')
  AUTH_JSON=$(printf "%s" "$AUTH_LINES"  | jq -Rsc 'split("\n")[:-1]')
  jq -n \
    --arg timestamp "$TIMESTAMP" \
    --arg instance_id "$INSTANCE_ID" \
    --argjson errors "$ERR_JSON" \
    --argjson events "$AUTH_JSON" \
    '{ timestamp: $timestamp, instance_id: $instance_id, errors: $errors, system_events: $events }' \
    > "$LOGS_TMP"
  jq empty "$LOGS_TMP" && mv -f "$LOGS_TMP" "$MONITOR_DIR/logs_status.json"
else
  # Fallback : échapper sommairement (moins sûr)
  ESC_ERR=$(printf "%s" "$ERROR_LINES" | sed 's/"/\\"/g' | sed 's/.*/"&",/' | sed '$ s/,$//')
  ESC_AUTH=$(printf "%s" "$AUTH_LINES" | sed 's/"/\\"/g' | sed 's/.*/"&",/' | sed '$ s/,$//')
  cat > "$MONITOR_DIR/logs_status.json" <<JSON
{
  "timestamp": "$TIMESTAMP",
  "instance_id": "$INSTANCE_ID",
  "errors": [ $ESC_ERR ],
  "system_events": [ $ESC_AUTH ]
}
JSON
fi

EOS

chmod +x "$MONITOR_DIR/monitoring.sh"

# 🕔 Ajout au cron (évite les doublons)
if ! grep -q "monitoring.sh" /etc/crontab; then
  echo "*/${CRON_INTERVAL} * * * * root $MONITOR_DIR/monitoring.sh" >> /etc/crontab
fi
