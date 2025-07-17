#!/bin/bash
set -e

# 1. Config générale
cat > /etc/bind/named.conf.options <<EOF2
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
EOF2

# 2. Déclaration de zone
cat > /etc/bind/named.conf.local <<EOF2
zone "camer.cm" {
    type master;
    file "/etc/bind/db.camer.cm";
};
EOF2

# 3. Fichier de zone simple
cat > /etc/bind/db.camer.cm <<EOF2
$TTL    604800
@       IN      SOA     ns1.camer.cm. admin.camer.cm. (
                              2025071001 ; Serial
                                 604800 ; Refresh
                                  86400 ; Retry
                                2419200 ; Expire
                                 604800 ) ; Negative Cache TTL

@       IN      NS      ns1.camer.cm.
ns1     IN      A       192.168.24.163
www     IN      A       192.168.24.163
EOF2

# 4. Vérification
echo "🔍 Vérification configuration :"
named-checkconf
named-checkzone camer.cm /etc/bind/db.camer.cm

# 5. Restart
systemctl restart bind9
systemctl status bind9 --no-pager

echo "✔️  Vérification finale..."
systemctl is-active bind9
named-checkconf && named-checkzone camer.cm /etc/bind/db.camer.cm

echo "✅ DNS CAMER.CM correctement installé et vérifié." > /var/log/dns_setup.log
