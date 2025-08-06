#!/bin/bash
set -e

: "${INSTANCE_ID:?INSTANCE_ID is required}"

# List of core and optional services to check
SERVICES=(
  sshd
  ufw
  fail2ban
  cron
  crond
  nginx
  apache2
  mysql
  mariadb
  postgresql
  docker
  kubelet
  redis-server
  mongod
  vsftpd
  proftpd
  php-fpm
)

TIMESTAMP=$(date --iso-8601=seconds)
{
  echo '{'
  for svc in "${SERVICES[@]}"; do
    status=$(systemctl is-active "$svc" 2>/dev/null || echo absent)
    echo "  \"$svc\": \"$status\","
  done
  echo "  \"timestamp\": \"$TIMESTAMP\",";
  echo "  \"instance_id\": \"$INSTANCE_ID\"";
  echo '}'
} | sudo tee /tmp/services_status.json > /dev/null

echo "${TIMESTAMP} [${INSTANCE_ID}] Services checked" >> /var/log/service.log

# Ensure cron entry exists to run every minute
SCRIPT_PATH=$(realpath "$0")
( crontab -l 2>/dev/null | grep -F "$SCRIPT_PATH" ) || \
  ( crontab -l 2>/dev/null; echo "* * * * * $SCRIPT_PATH >/dev/null 2>&1" ) | crontab -
