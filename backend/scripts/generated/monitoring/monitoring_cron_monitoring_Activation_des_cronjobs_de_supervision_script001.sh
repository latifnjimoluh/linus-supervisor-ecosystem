#!/bin/bash

# 📍 Ce script centralise l’installation des cronjobs de monitoring

# 🔐 Vérifie que les scripts à exécuter existent
STATUS_SCRIPT="/opt/monitoring/status.sh"
SERVICES_SCRIPT="/opt/monitoring/services_status.sh"

# 🧩 Crée les cronjobs uniquement s’ils n’existent pas déjà
if [ -f "$STATUS_SCRIPT" ]; then
  grep -q "$STATUS_SCRIPT" /etc/crontab || echo "*/5 * * * * root $STATUS_SCRIPT" >> /etc/crontab
  echo "✅ Cron job ajouté pour status.sh"
else
  echo "❌ Script $STATUS_SCRIPT introuvable"
fi

if [ -f "$SERVICES_SCRIPT" ]; then
  grep -q "$SERVICES_SCRIPT" /etc/crontab || echo "*/5 * * * * root $SERVICES_SCRIPT" >> /etc/crontab
  echo "✅ Cron job ajouté pour services_status.sh"
else
  echo "❌ Script $SERVICES_SCRIPT introuvable"
fi