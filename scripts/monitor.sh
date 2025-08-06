#!/bin/bash
set -e

# Require instance identifier, read from file if not provided
INSTANCE_FILE="/etc/instance-info.conf"
if [ -z "$INSTANCE_ID" ] && [ -f "$INSTANCE_FILE" ]; then
  INSTANCE_ID=$(grep -E '^INSTANCE_ID=' "$INSTANCE_FILE" | cut -d '=' -f2)
fi
: "${INSTANCE_ID:?INSTANCE_ID is required}"

TIMESTAMP=$(date --iso-8601=seconds)
HOSTNAME=$(hostname)
IP_ADDR=$(hostname -I | awk '{print $1}')
LOAD_AVG=$(uptime | awk -F'load average: ' '{print $2}')
MEM_TOTAL=$(grep MemTotal /proc/meminfo | awk '{print $2}')
MEM_AVAILABLE=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
DISK_TOTAL=$(df -B1 / | awk 'NR==2 {print $2}')
DISK_USED=$(df -B1 / | awk 'NR==2 {print $3}')
DISK_AVAIL=$(df -B1 / | awk 'NR==2 {print $4}')
IFACE=$(ip route show default | awk '/default/ {print $5}')
RX_BYTES=$(cat /sys/class/net/${IFACE}/statistics/rx_bytes)
TX_BYTES=$(cat /sys/class/net/${IFACE}/statistics/tx_bytes)
TOP_PROCESSES=$(ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 5 | awk '{printf "{\"pid\":%s,\"cmd\":\"%s\",\"cpu\":%s,\"mem\":%s}\n",$1,$2,$3,$4}' | paste -sd, -)
if command -v ss >/dev/null 2>&1; then
  OPEN_PORTS=$(ss -tuln | awk 'NR>1 {split($5,a,":"); print a[length(a)]}' | sort -n | uniq | awk '{printf "%s%s",(NR>1?",":""),$1}')
elif command -v netstat >/dev/null 2>&1; then
  OPEN_PORTS=$(netstat -tuln | awk 'NR>2 {split($4,a,":"); print a[length(a)]}' | sort -n | uniq | awk '{printf "%s%s",(NR>1?",":""),$1}')
else
  OPEN_PORTS=""
fi

cat <<JSON > /tmp/status.json
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
  "top_processes": [${TOP_PROCESSES}]
}
JSON

echo "${TIMESTAMP} [${INSTANCE_ID}] Metrics collected" >> /var/log/monitor.log

# Ensure cron entry exists to run every minute
(realpath "$0" >/dev/null 2>&1 && SCRIPT_PATH=$(realpath "$0")) || SCRIPT_PATH=$(readlink -f "$0")
( crontab -l 2>/dev/null | grep -F "$SCRIPT_PATH" ) || \
  ( crontab -l 2>/dev/null; echo "* * * * * $SCRIPT_PATH >/dev/null 2>&1" ) | crontab -