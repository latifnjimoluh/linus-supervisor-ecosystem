terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "= 3.0.2-rc01"
    }
    local = {
      source = "hashicorp/local"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}

provider "proxmox" {
  pm_api_url      = var.proxmox_api_url
  pm_user         = var.pm_user
  pm_password     = var.pm_password
  pm_tls_insecure = true
}

# 🧠 Calcul dynamique des adresses IP
locals {
  ipconfig_map = {
    for vm in var.vm_names :
    vm => (
      var.use_static_ip && contains(keys(var.static_ips), vm)
        ? "ip=${var.static_ips[vm]}/${var.network_cidr},gw=${var.gateway_ip}"
        : "ip=dhcp"
    )
  }
}

resource "proxmox_vm_qemu" "vm" {
  for_each    = toset(var.vm_names)
  name        = each.value
  target_node = var.proxmox_node
  clone       = var.template_name
  full_clone  = true
  os_type     = "cloud-init"
  agent       = 1

  memory = var.memory_mb

  cpu {
    cores   = var.vcpu_cores
    sockets = var.vcpu_sockets
  }

  scsihw   = "virtio-scsi-single"
  bootdisk = "scsi0"
  onboot   = true

  ciuser     = var.cloudinit_user
  cipassword = var.cloudinit_password
  sshkeys    = file(var.ssh_public_key_path)

  ipconfig0 = local.ipconfig_map[each.value]

  disk {
    slot     = "scsi0"
    type     = "disk"
    storage  = var.vm_storage
    size     = var.disk_size
    iothread = true
  }

  disk {
    slot    = "sata0"
    type    = "cloudinit"
    storage = var.vm_storage
  }

  disk {
    slot = "ide2"
    type = "cdrom"
  }

  network {
    id       = 0
    model    = "virtio"
    bridge   = var.vm_bridge
    firewall = false
  }

  timeouts {
    create = "10m"
  }
}

# 🚀 Déploiement distant des scripts init + config pour chaque VM
resource "null_resource" "configure_service" {
  for_each = var.service_config_scripts

  depends_on = [proxmox_vm_qemu.vm]

  triggers = {
    always_run = timestamp()
  }

  connection {
    type        = "ssh"
    host        = proxmox_vm_qemu.vm[each.key].default_ipv4_address
    user        = var.cloudinit_user
    private_key = file(var.ssh_private_key_path)
    timeout     = "2m"
  }

  provisioner "file" {
    source      = var.init_script
    destination = "/tmp/init.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "echo '🔧 Execution INIT SCRIPT...'",
      "chmod +x /tmp/init.sh",
      "sudo /tmp/init.sh",
      "echo '✅ Fin INIT SCRIPT'"
    ]
  }

  provisioner "file" {
    source      = each.value
    destination = "/tmp/config.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "echo '🔧 Execution CONFIG SCRIPT...'",
      "chmod +x /tmp/config.sh",
      "sudo /tmp/config.sh",
      "echo '✅ Fin INIT SCRIPT'"
    ]
  }

    provisioner "file" {
    source      = var.monitoring_script
    destination = "/tmp/monitoring.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "echo '🔧 Execution monitoring SCRIPT...'",
      "chmod +x /tmp/monitoring.sh",
      "sudo /tmp/monitoring.sh",
      "echo '✅ Fin INIT SCRIPT'"
    ]
  }

  # 🎯 Script de détection des services
  provisioner "file" {
    source      = var.monitoring_services_script
    destination = "/tmp/service-detector.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "echo '🔧 Execution service-detector SCRIPT...'",
      "chmod +x /tmp/service-detector.sh",
      "sudo /tmp/service-detector.sh",
      "echo '✅ Fin INIT SCRIPT'"
    ]
  }


}


