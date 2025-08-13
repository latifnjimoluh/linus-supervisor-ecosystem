#!/bin/bash
set -euo pipefail

# === Variables substituées par le moteur de template ===
SCRIPT_PATH="${SCRIPT_PATH}"
STATUS_SCRIPT_PATH="${STATUS_SCRIPT_PATH}"
SERVICES_SCRIPT_PATH="${SERVICES_SCRIPT_PATH}"
STATUS_CRON_EXPR='${STATUS_CRON_EXPR}'
SERVICES_CRON_EXPR='${SERVICES_CRON_EXPR}'
CRON_USER='${CRON_USER}'

MONITOR_DIR="$(dirname "${STATUS_SCRIPT_PATH}")"
MARK_BOOT="# MONITORING_CRON"
MARK_STATUS="# MONITORING_STATUS_CRON"
MARK_SERVICES="# MONITORING_SERVICES_CRON"

mkdir -p "${MONITOR_DIR}"

# --- Génère le script  ---
cat > "${SCRIPT_PATH}" <<'EOS'
#!/bin/bash
set -euo pipefail

STATUS_SCRIPT_PATH="__STATUS_SCRIPT_PATH__"
SERVICES_SCRIPT_PATH="__SERVICES_SCRIPT_PATH__"
STATUS_CRON_EXPR='__STATUS_CRON_EXPR__'
SERVICES_CRON_EXPR='__SERVICES_CRON_EXPR__'
CRON_USER='__CRON_USER__'
MARK_BOOT="# MONITORING_CRON"
MARK_STATUS="# MONITORING_STATUS_CRON"
MARK_SERVICES="# MONITORING_SERVICES_CRON"

exists_and_exec() {
  local f="$1"
  [[ -f "$f" ]] || return 1
  [[ -x "$f" ]] || chmod +x "$f" || true
  return 0
}

crontab_get() { crontab -u "$CRON_USER" -l 2>/dev/null || true; }
crontab_set() { crontab -u "$CRON_USER" -; }

add_cron_once() {
  local expr="$1" cmd="$2" mark="$3"
  local current
  current="$(crontab_get)"
  if ! echo "$current" | grep -Fq "$mark"; then
    { echo "$current" | grep -Fv "$mark"; echo "$expr $cmd $mark"; } | crontab_set
  fi
}

remove_mark() {
  local mark="$1"
  crontab_get | grep -Fv "$mark" | crontab_set
}

ok=1
if exists_and_exec "$STATUS_SCRIPT_PATH"; then
  add_cron_once "$STATUS_CRON_EXPR" "sudo bash $STATUS_SCRIPT_PATH >/opt/monitoring/status.log 2>&1" "$MARK_STATUS"
else
  ok=0
fi

if exists_and_exec "$SERVICES_SCRIPT_PATH"; then
  add_cron_once "$SERVICES_CRON_EXPR" "sudo bash $SERVICES_SCRIPT_PATH >/opt/monitoring/services_status.log 2>&1" "$MARK_SERVICES"
else
  ok=0
fi

if [[ "$ok" -eq 1 ]]; then
  # Exécuter une première fois tous les scripts pour générer les JSON immédiatement
  for script in /opt/monitoring/*.sh; do
    sudo bash "$script" || true
  done
  # Se retirer du crontab
  remove_mark "$MARK_BOOT"
fi
EOS

# Injecte les variables réelles dans le 
sed -i \
  -e "s#__STATUS_SCRIPT_PATH__#${STATUS_SCRIPT_PATH//\//\\/}#g" \
  -e "s#__SERVICES_SCRIPT_PATH__#${SERVICES_SCRIPT_PATH//\//\\/}#g" \
  -e "s#__STATUS_CRON_EXPR__#${STATUS_CRON_EXPR//\//\\/}#g" \
  -e "s#__SERVICES_CRON_EXPR__#${SERVICES_CRON_EXPR//\//\\/}#g" \
  -e "s#__CRON_USER__#${CRON_USER}#g" \
  "${SCRIPT_PATH}"

chmod +x "${SCRIPT_PATH}"

# --- (Ré)active le service cron/ crond ---
if command -v systemctl >/dev/null 2>&1; then
  systemctl enable --now cron 2>/dev/null || systemctl enable --now crond 2>/dev/null || true
fi

# --- Installe le cron  (toutes les minutes) ---
current_cron="$(crontab -u "${CRON_USER}" -l 2>/dev/null || true)"
if ! echo "$current_cron" | grep -Fq "$MARK_BOOT"; then
  { echo "$current_cron" | grep -Fv "$MARK_BOOT"; echo "* * * * * ${SCRIPT_PATH} $MARK_BOOT"; } | crontab -u "${CRON_USER}" -
fi

exit 0
