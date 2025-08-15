#!/bin/bash

# 📁 Créer le dossier de monitoring s’il n’existe pas
mkdir -p /opt/monitoring

# 📦 Créer le script de surveillance système
cat <<'EOS' > ${STATUS_SCRIPT_PATH}
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
  "top_processes": ${TOP_PROCESSES}
}
JSON
EOS

chown root:root ${STATUS_JSON_PATH}
chmod 644 ${STATUS_JSON_PATH}
chown root:root ${STATUS_SCRIPT_PATH}
chmod +x ${STATUS_SCRIPT_PATH}
