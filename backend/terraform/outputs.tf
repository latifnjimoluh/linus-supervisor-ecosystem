# 👉 Adresses IP des VMs
output "vm_ips" {
  description = "Adresses IP des machines virtuelles créées (via QEMU agent)"
  value = {
    for vm in proxmox_vm_qemu.vm :
    vm.name => vm.default_ipv4_address
  }
}

# 👉 Noms des VMs déployées
output "vm_names" {
  description = "Noms des VMs déployées"
  value       = [for vm in proxmox_vm_qemu.vm : vm.name]
}

# 👉 Commandes SSH personnalisées
output "ssh_commands" {
  description = "Commandes SSH pour accéder aux VMs"
  value = {
    for vm in proxmox_vm_qemu.vm :
    vm.name => "ssh -i ${var.ssh_private_key_path} ${var.cloudinit_user}@${vm.default_ipv4_address}"
  }
}


# 👉 Statut global du déploiement
output "status" {
  description = "Résumé du déploiement"
  value = <<EOT
✅ ${length(proxmox_vm_qemu.vm)} VM(s) déployée(s)
📄 Scripts injectés :
%{ for vm, scripts in var.scripts ~}
- ${vm} : ${join(", ", scripts)}
%{ endfor ~}
EOT
}

# 👉 IDs des VMs
output "vm_ids" {
  description = "IDs des machines virtuelles créées"
  value = {
    for vm in proxmox_vm_qemu.vm :
    vm.name => vm.vmid
  }
}
