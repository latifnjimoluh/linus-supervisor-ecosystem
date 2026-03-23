#!/bin/bash

# 📁 Créer le dossier de monitoring s’il n’existe pas
mkdir -p /opt/monitoring

# 📦 Créer le script de surveillance système
cat <<'EOS' > ${STATUS_SCRIPT_PATH}
#!/bin/bash

# 🔐 Charger l'INSTANCE_ID depuis /etc/instance-info.conf si présent
if [ -f /etc/instance-info.conf ]; then
  source /etc/instance-info.conf
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

TOP_PROCESSES=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | tail -n 5 | awk '{printf "{\"pid\":%s,\"cmd\":\"%s\",\"cpu\":%s},", $1, $2, $3}')
TOP_PROCESSES="[${TOP_PROCESSES%,}]"

# 🪵 Récupère les 20 dernières entrées de journal
RECENT_LOGS=$(journalctl -n 20 --no-pager --output=short | sed 's/"/\\"/g' | awk '{printf "{\"timestamp\":\"%s %s\",\"level\":\"info\",\"message\":\""; for(i=3;i<=NF;i++){printf "%s%s",$i,(i<NF?" ":"")} printf"\"},"}')
RECENT_LOGS="[${RECENT_LOGS%,}]"

cat <<JSON > ${STATUS_JSON_PATH}
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
  "top_processes": ${TOP_PROCESSES},
  "recent_logs": ${RECENT_LOGS}
}
JSON
EOS

chown root:root ${STATUS_JSON_PATH}
chmod 644 ${STATUS_JSON_PATH}
chown root:root ${STATUS_SCRIPT_PATH}
chmod +x ${STATUS_SCRIPT_PATH}
