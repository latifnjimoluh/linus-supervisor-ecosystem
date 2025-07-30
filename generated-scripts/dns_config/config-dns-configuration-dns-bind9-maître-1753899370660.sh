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
zone "camer.cm" {
    type master;
    file "/etc/bind/db.camer.cm";
};
EOF

# 4. Création du fichier de zone
cat > /etc/bind/db.camer.cm <<EOF
$TTL 604800
@   IN  SOA ns1.camer.cm. admin.camer.cm. (
        2025072901 ; Serial
        604800     ; Refresh
        86400      ; Retry
        2419200    ; Expire
        604800 )   ; Negative Cache TTL

@     IN      NS     ns1.camer.cm.
@     IN      NS     ns2.camer.cm.
ns1     IN      A     192.168.20.10
ns2     IN      A     192.168.20.20
www     IN      A     192.168.24.163
EOF

# 5. Permissions et vérifications
chown root:bind /etc/bind/db.camer.cm
chmod 644 /etc/bind/db.camer.cm

named-checkconf
named-checkzone camer.cm /etc/bind/db.camer.cm

# 6. Redémarrage du service
systemctl restart bind9
systemctl status bind9 --no-pager

# 7. Résultat
echo "✅ Serveur DNS Bind9 configuré pour camer.cm avec succès"