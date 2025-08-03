proxmox_api_url           = "https://192.168.24.134:8006/api2/json"
# proxmox_api_token_id      = "root@pam"
# proxmox_api_token_secret  = "Nexus2023."  # ou mieux : utiliser une variable d'environnement
proxmox_node              = "pve"
template_name             = "ubuntu-template"
vm_storage                = "local-lvm"

ssh_public_key_path       = "C:/Users/Nexus-PC/.ssh/id_rsa.pub"
cloudinit_user        = "nexus"
ssh_private_key_path  = "C:/Users/Nexus-PC/.ssh/id_rsa"

cloudinit_password        = "Nexus2023."
initialization_script = "Scripts/dns-install.sh"
# config_script = "Scripts/dns-configure.sh"

vm_names = ["dns"]
# use_static_ip = true

# static_ips = {
#   web-1 = "192.168.24.135"
#   web-2 = "192.168.24.136"
#   web-3 = "192.168.24.137"
# }
