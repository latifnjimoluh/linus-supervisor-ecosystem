##############################################
# Proxmox / Provider
##############################################

variable "proxmox_api_url" {
  description = "URL de l'API Proxmox (ex: https://pve:8006/api2/json)"
  type        = string
}

# --- Mode mot de passe (utilisé actuellement dans provider) ---
variable "pm_user" {
  description = "Utilisateur Proxmox (ex: root@pam)"
  type        = string
}

variable "pm_password" {
  description = "Mot de passe Proxmox"
  type        = string
  sensitive   = true
}

# --- Mode token (optionnel, à activer si tu modifies le provider) ---
variable "pm_api_token_id" {
  description = "ID du token API Proxmox (ex: user@realm!token-name). Laisse vide si tu utilises pm_user/pm_password."
  type        = string
  default     = ""
}

variable "pm_api_token_secret" {
  description = "Secret du token API Proxmox. Laisse vide si tu utilises pm_user/pm_password."
  type        = string
  sensitive   = true
  default     = ""
}

variable "proxmox_node" {
  description = "Nom du nœud Proxmox cible (ex: pve)"
  type        = string
}

##############################################
# Base VM / Clone
##############################################

variable "template_name" {
  description = "Nom du template Cloud-Init à cloner"
  type        = string
}

variable "vm_names" {
  description = "Liste des VMs à déployer"
  type        = list(string)

  validation {
    condition     = length(var.vm_names) > 0
    error_message = "vm_names ne doit pas être vide."
  }
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
  description = "Taille disque (ex: 20G, 50G, 10240M)"
  type        = string
  default     = "20G"

  validation {
    condition     = can(regex("^\\d+(G|M)$", var.disk_size))
    error_message = "disk_size doit être du format '<nombre>G' ou '<nombre>M' (ex: 20G, 10240M)."
  }
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

##############################################
# Cloud-Init / Accès
##############################################

variable "cloudinit_user" {
  description = "Nom d’utilisateur injecté (cloud-init)"
  type        = string
  default     = "nexus"
}

variable "cloudinit_password" {
  description = "Mot de passe injecté (cloud-init)"
  type        = string
  sensitive   = true
  default     = "nexus"
}

variable "ssh_public_key_path" {
  description = "Chemin de la clé publique SSH locale (ex: C:/Users/You/.ssh/id_rsa.pub)"
  type        = string
}

variable "ssh_private_key_path" {
  description = "Chemin de la clé privée SSH (ex: C:/Users/You/.ssh/id_rsa)"
  type        = string
}

##############################################
# Réseau
##############################################

variable "use_static_ip" {
  description = "Activer IP statique ?"
  type        = bool
  default     = false
}

variable "static_ips" {
  description = "IP statiques par nom de VM (ex: { web1 = \"192.168.1.10\" })"
  type        = map(string)
  default     = {}
}

variable "network_cidr" {
  description = "CIDR réseau (ex: 24)"
  type        = number
  default     = 24

  validation {
    condition     = var.network_cidr >= 0 && var.network_cidr <= 32
    error_message = "network_cidr doit être compris entre 0 et 32."
  }
}

variable "gateway_ip" {
  description = "Passerelle réseau"
  type        = string
  default     = "192.168.24.2"
}

##############################################
# Scripts à exécuter (SSH)
##############################################

variable "default_monitoring_script_path" {
  description = "Script monitoring par défaut injecté sur TOUTES les VMs"
  type        = string
  default     = "D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/monitoring.sh"
}


variable "scripts" {
  description = "Map VM => liste de chemins de scripts à exécuter dans l'ordre (en plus du monitoring par défaut)."
  type        = map(list(string))
  default     = {}
}

variable "instance_id" {
  description = "Identifiant unique de déploiement (propagé dans l'environnement des scripts)."
  type        = string
}

# Pas utilisé par le main.tf actuel, conservé pour compatibilité / traçabilité
variable "script_refs" {
  description = "Références aux scripts à injecter (type + id) — optionnel, seulement si consommé par ton backend."
  type        = list(object({
    type = string
    id   = number
  }))
  default = []
}

# Hérité de ta version précédente ; non utilisé si tu restes en pm_user/pm_password.
# Tu peux le supprimer et n'utiliser que pm_api_token_secret/pm_api_token_id ci-dessus.
variable "proxmox_api_token_secret" {
  description = "Token secret d’authentification Proxmox (hérité). Préfère pm_api_token_secret pour le provider."
  type        = string
  sensitive   = true
  default     = ""
}
