# 🔧 Linusupervisor Backend

Backend Node.js pour la plateforme de supervision intelligente des serveurs Linux du BUNEC.  
Il gère l’authentification sécurisée avec JWT, la base PostgreSQL, et servira plus tard à piloter les déploiements Terraform.

## ⚙️ Installation & Lancement

```bash
npm install
npm run dev


## ✅ `requirements.txt` (simulé pour mémoire)

Même si ce n’est pas utilisé comme en Python, voici un fichier que tu peux ajouter pour info ou documentation :

```txt
express
sequelize
pg
pg-hstore
dotenv
bcrypt
jsonwebtoken
cors
cookie-parser
helmet
compression


{
  "vm_names": ["dns"],
  "template_name": "ubuntu-template",
  "memory_mb": 2048,
  "vcpu_cores": 2,
  "vcpu_sockets": 1,
  "disk_size": "20G",
  "cloudinit_user": "nexus",
  "cloudinit_password": "Nexus2023.",
  "proxmox_api_url": "https://192.168.24.134:8006/api2/json",
  "proxmox_api_token_id": "root@pam",
  "proxmox_api_token_secret": "Nexus2023.",
  "proxmox_node": "pve",
  "vm_storage": "local-lvm",
  "vm_bridge": "vmbr0",
  "ssh_public_key_path": "C:/Users/Nexus-PC/.ssh/id_rsa.pub",
  "ssh_private_key_path": "C:/Users/Nexus-PC/.ssh/id_rsa",
  "dns_init_script": "Scripts/dns-install.sh",
  "dns_config_script": "Scripts/dns-configure.sh",
  "use_static_ip": false
}


{
  "vm_names": ["dns"],
  "template_name": "ubuntu-template",
  "memory_mb": 2048,
  "vcpu_cores": 2,
  "vcpu_sockets": 1,
  "disk_size": "20G",
  "cloudinit_user": "nexus",
  "cloudinit_password": "Nexus2023.",
  "proxmox_api_url": "https://192.168.24.134:8006/api2/json",
  "proxmox_api_token_id": "root@pam",
  "proxmox_api_token_secret": "Nexus2023.",
  "proxmox_node": "pve",
  "vm_storage": "local-lvm",
  "vm_bridge": "vmbr0",
  "ssh_public_key_path": "C:/Users/Nexus-PC/.ssh/id_rsa.pub",
  "ssh_private_key_path": "C:/Users/Nexus-PC/.ssh/id_rsa",
  "dns_init_script": "Scripts/dns-install.sh",
  "dns_config_script": "Scripts/dns-configure.sh",
  "use_static_ip": true,
  "static_ips": {
    "dns": "192.168.24.111"
  },
  "network_cidr": 24,
  "gateway_ip": "192.168.24.2"
}
