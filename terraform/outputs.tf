# 1. Adresses IP des VMs
output "vm_ips" {
  description = "Adresses IP des machines virtuelles créées (via QEMU agent)"
  value = {
    for vm in proxmox_vm_qemu.vm :
    vm.name => vm.default_ipv4_address
  }
}

# 2. Noms des VMs déployées
output "vm_names" {
  description = "Noms des VMs déployées"
  value       = [for vm in proxmox_vm_qemu.vm : vm.name]
}

# 3. Commandes SSH pour accès direct (utile pour debug ou test manuel)
output "ssh_commands" {
  description = "Commandes SSH pour se connecter aux VMs (à copier/coller)"
  value = {
    for vm in proxmox_vm_qemu.vm :
    vm.name => "ssh -i ${var.ssh_private_key_path} ${var.cloudinit_user}@${vm.default_ipv4_address}"
  }
}

# 4. Statut général de création
output "status" {
  description = "Statut de déploiement"
  value       = "✅ ${length(proxmox_vm_qemu.vm)} VM(s) déployée(s) avec script injecté : ${var.dns_init_script}"
}

output "dns_vm_ip" {
  value = proxmox_vm_qemu.vm["dns"].default_ipv4_address
}

output "dns_ssh_command" {
  value = "ssh -i ${var.ssh_private_key_path} ${var.cloudinit_user}@${proxmox_vm_qemu.vm["dns"].default_ipv4_address}"
}

output "dns_bind_status" {
  value = "systemctl status bind9 | grep Active"
}

output "dns_zone_config" {
  value = "cat /etc/bind/named.conf.local"
}

output "dns_zone_validation" {
  value = "named-checkconf && named-checkzone camer.cm /etc/bind/db.camer.cm"
}

output "dns_install_log" {
  value = "cat /var/log/dns_setup.log"
}
