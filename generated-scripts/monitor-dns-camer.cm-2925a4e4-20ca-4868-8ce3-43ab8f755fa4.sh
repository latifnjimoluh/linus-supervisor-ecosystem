#!/bin/bash

echo "🔧 Synchronisation de l'heure..."
timedatectl set-ntp true
ntpdate ntp.ubuntu.com || true

# 🔧 Installation des paquets nécessaires
apt-get update -qq
apt-get install -y -qq bind9 bind9utils bind9-doc dnsutils nmap netcat cron

# 📁 Script de supervision DNS (template dynamique)
cat > /opt/agent-superviseur-dns.sh <<'EOF'
#!/bin/bash

STATUS_FILE="/tmp/status.json"
ZONE_NAME="camer.cm"
ZONE_FILE="/etc/bind/db.${ZONE_NAME}"
CHECK_DOMAIN="www.camer.cm"
PORTS_TO_SCAN="22,53,80,443,1000-2000"

echo "{" > $STATUS_FILE
echo "\"hostname\": \"$(hostname)\"," >> $STATUS_FILE
echo "\"timestamp\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"," >> $STATUS_FILE

# 🔍 Vérification service DNS
BIND_STATUS=$(systemctl is-active bind9)
echo "\"bind9_status\": \"$BIND_STATUS\"," >> $STATUS_FILE

# 🔌 Port 53 actif
if ss -tunlp | grep -q ":53"; then
  echo "\"port_53\": \"listening\"," >> $STATUS_FILE
else
  echo "\"port_53\": \"closed\"," >> $STATUS_FILE
fi

# 🧪 named-checkconf
if named-checkconf >/dev/null 2>&1; then
  echo "\"named_checkconf\": \"ok\"," >> $STATUS_FILE
else
  echo "\"named_checkconf\": \"fail\"," >> $STATUS_FILE
fi

# 📄 Vérification de la zone
if [ -f "$ZONE_FILE" ]; then
  if named-checkzone "$ZONE_NAME" "$ZONE_FILE" | grep -q "OK"; then
    echo "\"zone_check\": \"ok\"," >> $STATUS_FILE
  else
    echo "\"zone_check\": \"fail\"," >> $STATUS_FILE
  fi
else
  echo "\"zone_check\": \"file_not_found\"," >> $STATUS_FILE
fi

# 🌐 Test dig
if dig +short @"127.0.0.1" "$CHECK_DOMAIN" | grep -q "."; then
  echo "\"dig_test_local\": \"success\"," >> $STATUS_FILE
else
  echo "\"dig_test_local\": \"fail\"," >> $STATUS_FILE
fi

# 🚪 Scan de ports (via nmap ou fallback netcat)
START_TIME=$(date +%s)

if command -v nmap &>/dev/null; then
  PORTS=$(nmap -p $PORTS_TO_SCAN localhost | grep "^ *[0-9]" | awk '{print $1}' | cut -d'/' -f1 | tr '\n' ',' | sed 's/,$//')
  echo "\"open_ports\": \"$PORTS\"," >> $STATUS_FILE
else
  PORTS_FOUND=""
  for port in $(echo $PORTS_TO_SCAN | tr ',' ' '); do
    (echo >/dev/tcp/127.0.0.1/$port) >/dev/null 2>&1 && PORTS_FOUND+="$port,"
  done
  PORTS_FOUND=$(echo "$PORTS_FOUND" | sed 's/,$//')
  echo "\"open_ports_telnet\": \"$PORTS_FOUND\"," >> $STATUS_FILE
fi

END_TIME=$(date +%s)
SCAN_DURATION=$((END_TIME - START_TIME))
echo "\"scan_duration_seconds\": $SCAN_DURATION," >> $STATUS_FILE

if [ "$SCAN_DURATION" -gt 10 ]; then
  echo "\"scan_warning\": \"Scan took more than 10 seconds\"," >> $STATUS_FILE
fi

# 📊 Ressources système
CPU_LOAD=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
echo "\"cpu_load\": \"$CPU_LOAD\"," >> $STATUS_FILE

RAM_USED=$(free -m | awk '/Mem:/ { printf("%.0f", ($3/$2)*100) }')
echo "\"ram_usage\": \"$RAM_USED%\"," >> $STATUS_FILE

DISK_USED=$(df -h / | awk 'NR==2 {print $5}')
echo "\"disk_usage\": \"$DISK_USED\"" >> $STATUS_FILE

echo "}" >> $STATUS_FILE
EOF

# 🔐 Permissions + cron job dynamique
chmod +x /opt/agent-superviseur-dns.sh
(crontab -l 2>/dev/null; echo "*/5 * * * * /opt/agent-superviseur-dns.sh > /dev/null") | crontab -

echo "🛠️ Installation du serveur DNS (bind9)..."
echo "✅ Installation du superviseur DNS pour la zone camer.cm terminée."
