variable "proxmox_api_url" {
  description = "URL de l'API Proxmox (ex: https://192.168.1.10:8006/api2/json)"
  type        = string
}

variable "proxmox_api_token_id" {
  description = "Identifiant du token API (ex: root@pam!terraform)"
  type        = string
}

variable "proxmox_api_token_secret" {
  description = "Clé secrète du token API"
  type        = string
  sensitive   = true
}

variable "proxmox_node" {
  description = "Nom du nœud Proxmox cible"
  type        = string
}

variable "template_name" {
  description = "Nom du template Cloud-Init à cloner"
  type        = string
}

variable "vm_names" {
  description = "Liste ou ensemble des noms de VMs à créer"
  type        = set(string)
}

variable "memory_mb" {
  description = "Quantité de mémoire (en Mo) par VM"
  type        = number
  default     = 2048
}

variable "vcpu_cores" {
  description = "Nombre de cœurs CPU par VM"
  type        = number
  default     = 2
}

variable "vcpu_sockets" {
  description = "Nombre de sockets CPU par VM"
  type        = number
  default     = 1
}

variable "disk_size" {
  description = "Taille du disque principal (ex: 20G)"
  type        = string
  default     = "20G"
}

variable "vm_storage" {
  description = "Nom du stockage Proxmox (ex: local-lvm)"
  type        = string
}

variable "vm_bridge" {
  description = "Bridge réseau Proxmox (ex: vmbr0)"
  type        = string
  default     = "vmbr0"
}

variable "cloudinit_user" {
  description = "Nom d'utilisateur à injecter via Cloud-Init"
  type        = string
  default     = "nexus"
}

variable "cloudinit_password" {
  description = "Mot de passe de l'utilisateur (injection Cloud-Init)"
  type        = string
  sensitive   = true
}

variable "ssh_public_key_path" {
  description = "Chemin local du fichier clé publique SSH (ex: ~/.ssh/id_rsa.pub)"
  type        = string
}

variable "ssh_private_key_path" {
  description = "Chemin vers la clé SSH privée"
  type        = string
}

variable "dns_init_script" {
  description = "Chemin local du script bash à injecter dans la VM"
  type        = string
}

variable "dns_config_script" {
  description = "Configuration des zones DNS"
  type        = string
}

variable "use_static_ip" {
  description = "Activer les IPs statiques si true, sinon DHCP"
  type        = bool
  default     = false
}

variable "static_ips" {
  description = "Map des IPs statiques (clé = nom de VM)"
  type        = map(string)
  default     = {}
}

variable "network_cidr" {
  description = "Masque réseau (ex: 24 pour 255.255.255.0)"
  type        = number
  default     = 24
}

variable "gateway_ip" {
  description = "IP de la passerelle réseau"
  type        = string
  default     = "192.168.24.2"
}

variable "service_config_scripts" {
  type        = map(string)
  description = "Scripts de configuration par service ex: { dns = '/chemin/script.sh' }"
}
