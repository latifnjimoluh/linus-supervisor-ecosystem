#!/bin/bash

# 📌 Instance ID injecté par Terraform
INSTANCE_ID="${instance_id}"

# 💾 Sauvegarde localement
echo "INSTANCE_ID=$INSTANCE_ID" | sudo tee /etc/instance-info.conf > /dev/null

# 🔧 Export pour tous les services système
echo "export INSTANCE_ID=$INSTANCE_ID" | sudo tee -a /etc/profile.d/instance_id.sh > /dev/null
chmod +x /etc/profile.d/instance_id.sh

echo "🔧 Initialisation de la supervision des services..."

# Liste des services à injecter
cat > /opt/services-to-watch.txt <<EOF
{{SERVICES}}
EOF

# Script de détection
cat > /opt/detect-services.sh <<'EOF'
#!/bin/bash

OUTPUT="/tmp/services_status.json"
HOSTNAME=$(hostname)
TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)

echo "{" > "$OUTPUT"
echo "  \"hostname\": \"$HOSTNAME\"," >> "$OUTPUT"
echo "  \"timestamp\": \"$TIMESTAMP\"," >> "$OUTPUT"
echo "  \"services\": [" >> "$OUTPUT"

FIRST=true
while read svc; do
  svc=$(echo "$svc" | xargs)  # Trim
  [[ -z "$svc" ]] && continue

  enabled=$(systemctl is-enabled "$svc" 2>/dev/null)
  active=$(systemctl is-active "$svc" 2>/dev/null)

  if [[ "$enabled" == "not-found" || "$enabled" == "" || "$enabled" == "masked" ]]; then
    continue
  fi

  active=$(echo "$active" | tr -d '\n')

  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    echo "," >> "$OUTPUT"
  fi

  echo "    {" >> "$OUTPUT"
  echo "      \"name\": \"$svc\"," >> "$OUTPUT"
  echo "      \"enabled\": \"$enabled\"," >> "$OUTPUT"
  echo "      \"active\": \"$active\"" >> "$OUTPUT"
  echo "    }" >> "$OUTPUT"
done < /opt/services-to-watch.txt

echo "  ]" >> "$OUTPUT"
echo "}" >> "$OUTPUT"
EOF

chmod +x /opt/detect-services.sh

# Planifier avec cron
(crontab -l 2>/dev/null; echo "*/{{CRON_INTERVAL}} * * * * /opt/detect-services.sh > /dev/null 2>&1") | crontab -

echo "✅ Agent de supervision des services installé et planifié toutes les {{CRON_INTERVAL}} minutes."