#!/bin/bash
set -e

# Require instance identifier injected at deployment
: "${INSTANCE_ID:?INSTANCE_ID is required}"

CPU_LOAD=$(uptime | awk -F'load average: ' '{print $2}')
echo "$(date --iso-8601=seconds) [${INSTANCE_ID}] CPU load: $CPU_LOAD" >> /var/log/monitor.log
