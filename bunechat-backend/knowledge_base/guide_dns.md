# Guide DNS interne (BUNEC) — BIND9 sur Ubuntu 22.04

## Objectif
Déployer un **DNS interne** qui fait :
- **Autoritatif** pour le domaine interne `bunec.local` (et la zone inverse du LAN).
- **Récursif** uniquement pour le LAN (clients internes).
- Journalisation, RRL (rate-limit), transferts de zones sécurisés (TSIG, optionnel).

## Hypothèses / Exemples
- OS : Ubuntu 22.04 LTS
- DNS primaire (ns1) : `10.10.0.10`
- DNS secondaire (ns2, optionnel) : `10.10.0.11`
- Domaine : `bunec.local`
- Sous-réseau LAN : `10.10.0.0/24` (CIDR /24)
- Zone inverse : `0.10.10.in-addr.arpa`
- Forwarders (externe) : `1.1.1.1`, `8.8.8.8`

## Pré-requis
- Accès root/`sudo`.
- Port **53** disponible (désactiver `systemd-resolved` si besoin).
- Horloge à l’heure (NTP), utile pour DNSSEC.

## Désactiver le stub resolver (si conflit port 53)
```bash
sudo sed -i 's/^#\?DNSStubListener=.*/DNSStubListener=no/' /etc/systemd/resolved.conf
sudo systemctl restart systemd-resolved
# Facultatif: pointer /etc/resolv.conf vers un fichier statique
# sudo ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf


Installation
bash
Copier
Modifier
sudo apt update
sudo apt install -y bind9 bind9-utils bind9-doc
sudo systemctl enable --now bind9
Arborescence & fichiers BIND
/etc/bind/named.conf (inclut options/local/default-zones)

/etc/bind/named.conf.options (écoute, recursion, forwarders, dnssec, logging)

/etc/bind/named.conf.local (déclarations de zones)

/etc/bind/zones/ (fichiers de zone personnalisés)

Crée le dossier zones :

bash
Copier
Modifier
sudo mkdir -p /etc/bind/zones
sudo chown bind:bind /etc/bind/zones
named.conf.options (exemple commenté)
conf
Copier
Modifier
options {
  directory "/var/cache/bind";

  // écoute
  listen-on { 10.10.0.10; 127.0.0.1; };
  listen-on-v6 { any; };

  // ACL & récursion
  acl "lan" { 10.10.0.0/24; 127.0.0.1; };
  allow-query     { any; };
  allow-recursion { "lan"; };

  // Transferts autorisés (si ns2)
  // allow-transfer { 10.10.0.11; };

  // Réémet les requêtes inconnues vers des DNS publics
  forwarders { 1.1.1.1; 8.8.8.8; };
  forward only;

  // DNSSEC (par défaut sur Ubuntu)
  dnssec-validation auto;

  // Rate limiting (anti-amplification)
  rate-limit {
    responses-per-second 15;
    slip 2;
  };

  // Logging minimal (voir section Logging)
  // version "not-disclosed";
};
named.conf.local (zones)
conf
Copier
Modifier
zone "bunec.local" {
  type master;
  file "/etc/bind/zones/db.bunec.local";
  // ixfr-from-differences yes;
  // also-notify { 10.10.0.11; };  // ns2
  // allow-update { key "ddns-key"; }; // si DDNS
};

zone "0.10.10.in-addr.arpa" {
  type master;
  file "/etc/bind/zones/db.10.10.0.rev";
};
Fichier de zone directe db.bunec.local
dns
Copier
Modifier
$TTL 3600
@   IN SOA ns1.bunec.local. admin.bunec.local. (
        2025080901 ; Serial (YYYYMMDDnn)
        3600       ; Refresh
        900        ; Retry
        1209600    ; Expire
        300 )      ; Negative Cache

    IN  NS   ns1.bunec.local.
;   IN  NS   ns2.bunec.local.   ; décommente si secondaire

ns1 IN  A    10.10.0.10
ns2 IN  A    10.10.0.11
; hôtes internes usuels
bastion   IN A 10.10.0.5
proxmox   IN A 10.10.0.20
registry  IN A 10.10.0.30
monitor   IN A 10.10.0.40

; alias (CNAME)
pve   IN CNAME proxmox
graf  IN CNAME monitor
Fichier de zone inverse db.10.10.0.rev
dns
Copier
Modifier
$TTL 3600
@   IN SOA ns1.bunec.local. admin.bunec.local. (
        2025080901 ; Serial
        3600
        900
        1209600
        300 )
    IN NS ns1.bunec.local.

10  IN PTR ns1.bunec.local.
11  IN PTR ns2.bunec.local.
5   IN PTR bastion.bunec.local.
20  IN PTR proxmox.bunec.local.
30  IN PTR registry.bunec.local.
40  IN PTR monitor.bunec.local.
⚠️ Serial : incrémente à chaque modification (ex. YYYYMMDDnn).

Vérifications
bash
Copier
Modifier
sudo named-checkconf
sudo named-checkzone bunec.local /etc/bind/zones/db.bunec.local
sudo named-checkzone 0.10.10.in-addr.arpa /etc/bind/zones/db.10.10.0.rev
sudo systemctl restart bind9
sudo journalctl -u bind9 -b -n 50 --no-pager
Tests (depuis un client)
bash
Copier
Modifier
dig @10.10.0.10 ns1.bunec.local A +short
dig @10.10.0.10 bunec.local SOA
dig @10.10.0.10 -x 10.10.0.20 +short
dig @10.10.0.10 google.com A +stats
Logging (exemple)
Dans named.conf.options, ajouter :

conf
Copier
Modifier
logging {
  channel default_log {
    file "/var/log/named/default.log" versions 5 size 10m;
    severity info;
    print-time yes; print-severity yes; print-category yes;
  };
  category default { default_log; };
  category queries { default_log; };
};
Puis :

bash
Copier
Modifier
sudo mkdir -p /var/log/named
sudo chown bind:bind /var/log/named
sudo systemctl restart bind9
tail -f /var/log/named/default.log
Sécurité (principes)
Récursion seulement pour le LAN (allow-recursion).

Transferts limités aux secondaires (allow-transfer + éventuellement TSIG).

RRL activé pour limiter l’amplification.

Masquer la version (version "not-disclosed";).

Sauvegardes des zones (/etc/bind/zones) et Serial rigoureux.

Intégration Proxmox/Cloud-Init (rappel)
VMs doivent pointer vers 10.10.0.10 (et 10.10.0.11 si secondaire).

Cloud-Init : paramètre dns_nameservers: [10.10.0.10, 10.10.0.11].

Dépannage rapide
sudo ss -lntup | grep :53 — vérifier qui écoute.

journalctl -u bind9 -n 100 — erreurs de syntaxe ?

named-checkzone & named-checkconf — rechercher les ; manquants.

Firewall : ouvrir 53/tcp, 53/udp.

SERVFAIL/REFUSED → voir erreurs_connues.txt