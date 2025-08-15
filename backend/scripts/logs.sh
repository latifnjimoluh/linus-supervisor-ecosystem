#!/bin/bash
set -euo pipefail

# 📁 Dossier de sortie personnalisable
MONITOR_DIR="${MONITOR_DIR:-/opt/monitoring}"
mkdir -p "$MONITOR_DIR"

# Ensure instance ID exists
if [ ! -f /etc/instance-info.conf ]; then
  uuid=$(command -v uuidgen >/dev/null 2>&1 && uuidgen || cat /proc/sys/kernel/random/uuid)
  echo "INSTANCE_ID=$uuid" > /etc/instance-info.conf
fi

# 📦 Créer le script de collecte des logs
cat <<'EOS' > "$MONITOR_DIR/logs.sh"
#!/bin/bash
set -euo pipefail

# Répertoire cible (par défaut le dossier du script)
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

chmod +x "$MONITOR_DIR/logs.sh"

# 🕔 Ajout au cron (évite les doublons)
grep -q "logs.sh" /etc/crontab || echo "*/5 * * * * root $MONITOR_DIR/logs.sh" >> /etc/crontab

