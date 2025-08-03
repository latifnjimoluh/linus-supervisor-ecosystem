# 1️⃣ Adresses IP des VMs
output "vm_ips" {
  description = "Adresses IP des machines virtuelles créées (via QEMU agent)"
  value = {
    for vm in proxmox_vm_qemu.vm :
    vm.name => vm.default_ipv4_address
  }
}

# 2️⃣ Noms des VMs déployées
output "vm_names" {
  description = "Noms des VMs déployées"
  value       = [for vm in proxmox_vm_qemu.vm : vm.name]
}

# 3️⃣ Commandes SSH personnalisées
output "ssh_commands" {
  description = "Commandes SSH pour accéder aux VMs"
  value = {
    for vm in proxmox_vm_qemu.vm :
    vm.name => "ssh -i ${var.ssh_private_key_path} ${var.cloudinit_user}@${vm.default_ipv4_address}"
  }
}

# 4️⃣ Statut global du déploiement
output "status" {
  description = "Résumé du déploiement"
  value = <<EOT
✅ ${length(proxmox_vm_qemu.vm)} VM(s) déployée(s)
🟢 Script d'initialisation : ${var.initialization_script}
🧩 Scripts de service injectés :
%{ for name, path in var.service_config_scripts ~}
- ${name} : ${path}
%{ endfor ~}
EOT
}

output "vm_ids" {
  description = "IDs des machines virtuelles créées"
  value = {
    for vm in proxmox_vm_qemu.vm :
    vm.name => vm.vmid
  }
}
# 5️⃣ Informations sur les services déployés