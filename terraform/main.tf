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
  pm_user         = var.proxmox_api_token_id
  pm_password     = var.proxmox_api_token_secret
  pm_tls_insecure = true
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

  ipconfig0 = var.use_static_ip && contains(keys(var.static_ips), each.value) ? "ip=${var.static_ips[each.value]}/${var.network_cidr},gw=${var.gateway_ip}" : "ip=dhcp"


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

# Connexion SSH
resource "null_resource" "dns_install" {
  for_each = toset(var.vm_names)

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
    source      = var.dns_init_script
    destination = "/tmp/dns-install.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/dns-install.sh",
      "sudo /tmp/dns-install.sh"
    ]
  }

  provisioner "file" {
    source      = var.dns_config_script
    destination = "/tmp/dns-configure.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/dns-configure.sh",
      "sudo /tmp/dns-configure.sh"
    ]
  }
}
