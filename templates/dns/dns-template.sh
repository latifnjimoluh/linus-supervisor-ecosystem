#!/bin/bash
set -e

echo "🔧 Synchronisation de l'heure..."
timedatectl set-ntp true
ntpdate ntp.ubuntu.com || true

echo "🛠️ Installation du serveur DNS (bind9)..."
apt-get update -y
apt-get install -y bind9 bind9utils bind9-doc dnsutils

echo "✅ Installation terminée."

# 1. Config générale
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

# 2. Déclaration de zone
cat > /etc/bind/named.conf.local <<EOF
zone "{{zone_name}}" {
    type master;
    file "/etc/bind/db.{{zone_name}}";
};
EOF

# 3. Fichier de zone simple
cat > /etc/bind/db.{{zone_name}} <<EOF
\$TTL    604800
@       IN      SOA     {{fqdn_ns}}. {{admin_email}}. (
                              {{serial}} ; Serial
                                 604800 ; Refresh
                                  86400 ; Retry
                                2419200 ; Expire
                                 604800 ) ; Negative Cache TTL

{{dns_records}}
EOF

# 4. Vérification
echo "🔍 Vérification configuration :"
named-checkconf
named-checkzone {{zone_name}} /etc/bind/db.{{zone_name}}

# 5. Restart
systemctl restart bind9
systemctl status bind9 --no-pager

echo "✔️  Vérification finale..."
systemctl is-active bind9
named-checkconf && named-checkzone {{zone_name}} /etc/bind/db.{{zone_name}}

echo "✅ DNS {{zone_name}} correctement installé et vérifié." > /var/log/dns_setup.log
