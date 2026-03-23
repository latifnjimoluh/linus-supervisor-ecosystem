variable "proxmox_api_url" {
  description = "URL de l'API Proxmox"
  type        = string
}

variable "pm_user" {
  description = "Utilisateur Proxmox (ex: root@pam)"
  type        = string
}

variable "pm_password" {
  description = "Mot de passe Proxmox"
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
  description = "Liste des VMs à déployer"
  type        = set(string)
}

variable "memory_mb" {
  description = "RAM (en Mo)"
  type        = number
  default     = 2048
}

variable "vcpu_cores" {
  description = "Nombre de cœurs"
  type        = number
  default     = 2
}

variable "vcpu_sockets" {
  description = "Nombre de sockets"
  type        = number
  default     = 1
}

variable "disk_size" {
  description = "Taille disque (ex: 20G)"
  type        = string
  default     = "20G"
}

variable "vm_storage" {
  description = "Stockage Proxmox (ex: local-lvm)"
  type        = string
}

variable "vm_bridge" {
  description = "Bridge réseau (ex: vmbr0)"
  type        = string
  default     = "vmbr0"
}

variable "cloudinit_user" {
  description = "Nom d’utilisateur injecté (cloud-init)"
  type        = string
  default     = "nexus"
}

variable "cloudinit_password" {
  description = "Mot de passe injecté (cloud-init)"
  type        = string
  sensitive   = true
}

variable "ssh_public_key_path" {
  description = "Clé publique SSH locale"
  type        = string
}

variable "ssh_private_key_path" {
  description = "Clé privée SSH"
  type        = string
}

variable "use_static_ip" {
  description = "Activer IP statique ?"
  type        = bool
  default     = false
}

variable "static_ips" {
  description = "IP statiques par nom de VM"
  type        = map(string)
  default     = {}
}

variable "network_cidr" {
  description = "CIDR réseau (ex: 24)"
  type        = number
  default     = 24
}

variable "gateway_ip" {
  description = "Passerelle réseau"
  type        = string
  default     = "192.168.24.2"
}

variable "scripts" {
  description = "Map VM => liste de chemins de scripts à exécuter dans l'ordre"
  type        = map(list(string))
  default     = {}
}

variable "instance_id" {
  description = "Identifiant unique de déploiement"
  type        = string
}

variable "script_refs" {
  description = "Références aux scripts à injecter (type + id)"
  type        = list(object({
    type = string
    id   = number
  }))
  default = []
}

variable "proxmox_api_token_secret" {
  description = "Token secret d’authentification Proxmox"
  type        = string
}
