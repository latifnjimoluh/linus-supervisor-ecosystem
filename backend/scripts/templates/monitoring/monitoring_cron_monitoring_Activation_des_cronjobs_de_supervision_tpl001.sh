#!/bin/bash

# 📍 Ce script centralise l’installation des cronjobs de monitoring

# 🔐 Vérifie que les scripts à exécuter existent
STATUS_SCRIPT="${STATUS_SCRIPT}"
SERVICES_SCRIPT="${SERVICES_SCRIPT}"

# 🧩 Crée les cronjobs uniquement s’ils n’existent pas déjà
if [ -f "$STATUS_SCRIPT" ]; then
  grep -q "$STATUS_SCRIPT" /etc/crontab || echo "*/${STATUS_CRON_INTERVAL} * * * * root $STATUS_SCRIPT" >> /etc/crontab
  echo "✅ Cron job ajouté pour status.sh"
else
  echo "❌ Script $STATUS_SCRIPT introuvable"
fi

if [ -f "$SERVICES_SCRIPT" ]; then
  grep -q "$SERVICES_SCRIPT" /etc/crontab || echo "*/${SERVICES_CRON_INTERVAL} * * * * root $SERVICES_SCRIPT" >> /etc/crontab
  echo "✅ Cron job ajouté pour services_status.sh"
else
  echo "❌ Script $SERVICES_SCRIPT introuvable"
fi