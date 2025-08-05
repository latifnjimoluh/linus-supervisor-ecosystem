#!/bin/bash
set -e

# Require deployment to inject instance identifier
: "${INSTANCE_ID:?INSTANCE_ID is required}"

if ! systemctl is-active --quiet nginx; then
  systemctl restart nginx
  echo "$(date --iso-8601=seconds) [${INSTANCE_ID}] Nginx restarted" >> /var/log/service.log
fi
