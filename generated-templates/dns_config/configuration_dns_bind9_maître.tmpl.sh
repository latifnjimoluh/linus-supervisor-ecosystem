#!/bin/bash
set -e

[ "$EUID" -ne 0 ] && echo "❌ Ce script doit être exécuté en root (sudo)." && exit 1

echo "🛠️ Installation et configuration de Bind9 (serveur maître)..."

# 1. Installation des paquets nécessaires
apt-get update -qq
apt-get install -y bind9 bind9utils bind9-doc dnsutils

# 2. Configuration globale
cat > /etc/bind/named.conf.options <<EOF
options {
    directory "/var/cache/bind";
    recursion yes;
    allow-query { any; };
    forwarders {
        8.8.8.8;
    };
    listen-on { any; };
    listen-on-v6 { none; };
};
EOF

# 3. Configuration des zones locales
cat > /etc/bind/named.conf.local <<EOF
zone "{{ZONE_NAME}}" {
    type master;
    file "/etc/bind/db.{{ZONE_NAME}}";
};
EOF

# 4. Création du fichier de zone
cat > /etc/bind/db.{{ZONE_NAME}} <<EOF
$TTL 604800
@   IN  SOA {{FQDN_NS}} {{ADMIN_EMAIL}} (
        {{SERIAL}} ; Serial
        604800     ; Refresh
        86400      ; Retry
        2419200    ; Expire
        604800 )   ; Negative Cache TTL

{{DNS_RECORDS}}
EOF

# 5. Permissions et vérifications
chown root:bind /etc/bind/db.{{ZONE_NAME}}
chmod 644 /etc/bind/db.{{ZONE_NAME}}

named-checkconf
named-checkzone {{ZONE_NAME}} /etc/bind/db.{{ZONE_NAME}}

# 6. Redémarrage du service
systemctl restart bind9
systemctl status bind9 --no-pager

# 7. Résultat
echo "✅ Serveur DNS Bind9 configuré pour {{ZONE_NAME}} avec succès"