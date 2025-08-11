
---

## `knowledge_base/dns-install.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail

# === Paramètres à ADAPTER ===
DOMAIN="bunec.local"
LAN_CIDR="10.10.0.0/24"
DNS1_IP="10.10.0.10"
DNS2_IP="10.10.0.11"   # facultatif
FORWARDERS=("1.1.1.1" "8.8.8.8")
REV_ZONE="0.10.10.in-addr.arpa"
REV_PREFIX_NET="10.10.0"  # pour PTR (dernier octet sera ajouté)
TTL="3600"

# === Préchecks ===
if [[ $EUID -ne 0 ]]; then
  echo "Run as root (sudo)"; exit 1
fi

echo "[1/8] Désactivation éventuelle de systemd-resolved (port 53)"
sed -i 's/^#\?DNSStubListener=.*/DNSStubListener=no/' /etc/systemd/resolved.conf || true
systemctl restart systemd-resolved || true

echo "[2/8] Installation BIND9"
apt-get update -y
apt-get install -y bind9 bind9-utils bind9-doc

echo "[3/8] Arborescence"
mkdir -p /etc/bind/zones
chown bind:bind /etc/bind/zones

echo "[4/8] named.conf.options"
{
  echo "options {"
  echo "  directory \"/var/cache/bind\";"
  echo "  listen-on { ${DNS1_IP}; 127.0.0.1; };"
  echo "  listen-on-v6 { any; };"
  echo "  acl \"lan\" { ${LAN_CIDR}; 127.0.0.1; };"
  echo "  allow-query { any; };"
  echo "  allow-recursion { \"lan\"; };"
  if [[ -n "${DNS2_IP:-}" ]]; then
    echo "  // allow-transfer { ${DNS2_IP}; };"
    echo "  // also-notify { ${DNS2_IP}; };"
  fi
  echo -n "  forwarders {"
  for f in "${FORWARDERS[@]}"; do echo -n " ${f};"; done
  echo " };"
  echo "  forward only;"
  echo "  dnssec-validation auto;"
  echo "  rate-limit { responses-per-second 15; slip 2; };"
  echo "  // version \"not-disclosed\";"
  echo "};"
} > /etc/bind/named.conf.options

echo "[5/8] named.conf.local (zones)"
cat > /etc/bind/named.conf.local <<EOF
zone "${DOMAIN}" {
  type master;
  file "/etc/bind/zones/db.${DOMAIN}";
};

zone "${REV_ZONE}" {
  type master;
  file "/etc/bind/zones/db.${REV_PREFIX_NET}.rev";
};
EOF

echo "[6/8] Zone directe db.${DOMAIN}"
SERIAL="$(date +%Y%m%d)01"
cat > /etc/bind/zones/db.${DOMAIN} <<EOF
\$TTL ${TTL}
@   IN SOA ns1.${DOMAIN}. admin.${DOMAIN}. (
        ${SERIAL} ; Serial
        3600      ; Refresh
        900       ; Retry
        1209600   ; Expire
        300 )     ; Negative Cache
    IN NS ns1.${DOMAIN}.
;   IN NS ns2.${DOMAIN}.

ns1 IN A ${DNS1_IP}
EOF
if [[ -n "${DNS2_IP:-}" ]]; then
  echo "ns2 IN A ${DNS2_IP}" >> /etc/bind/zones/db.${DOMAIN}
fi

# hôtes de base
cat >> /etc/bind/zones/db.${DOMAIN} <<'EOF'
bastion   IN A 10.10.0.5
proxmox   IN A 10.10.0.20
registry  IN A 10.10.0.30
monitor   IN A 10.10.0.40
pve       IN CNAME proxmox
graf      IN CNAME monitor
EOF

echo "[7/8] Zone inverse db.${REV_PREFIX_NET}.rev"
cat > /etc/bind/zones/db.${REV_PREFIX_NET}.rev <<EOF
\$TTL ${TTL}
@   IN SOA ns1.${DOMAIN}. admin.${DOMAIN}. (
        ${SERIAL}
        3600
        900
        1209600
        300 )
    IN NS ns1.${DOMAIN}.
10  IN PTR ns1.${DOMAIN}.
5   IN PTR bastion.${DOMAIN}.
20  IN PTR proxmox.${DOMAIN}.
30  IN PTR registry.${DOMAIN}.
40  IN PTR monitor.${DOMAIN}.
EOF
if [[ -n "${DNS2_IP:-}" ]]; then
  echo "11  IN PTR ns2.${DOMAIN}." >> /etc/bind/zones/db.${REV_PREFIX_NET}.rev
fi

echo "[8/8] Vérifications & démarrage"
named-checkconf
named-checkzone "${DOMAIN}" /etc/bind/zones/db.${DOMAIN}
named-checkzone "${REV_ZONE}" /etc/bind/zones/db.${REV_PREFIX_NET}.rev
systemctl enable --now bind9
systemctl restart bind9
sleep 2
systemctl --no-pager --full status bind9 || true

echo "OUVERTURE FIREWALL (si UFW)"
if command -v ufw >/dev/null 2>&1; then
  ufw allow 53/tcp || true
  ufw allow 53/udp || true
fi

echo "TESTS RAPIDES:"
echo "  dig @${DNS1_IP} ns1.${DOMAIN} A +short"
echo "  dig @${DNS1_IP} -x ${REV_PREFIX_NET}.20 +short   # PTR proxmox"
echo "  dig @${DNS1_IP} google.com A +stats              # récursion/forwarders"
echo "OK."
