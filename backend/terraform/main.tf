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

# 🧬 IP + scripts à pousser
locals {
  ipconfig_map = {
    for vm in var.vm_names :
    vm => (
      var.use_static_ip && contains(keys(var.static_ips), vm)
        ? "ip=${var.static_ips[vm]}/${var.network_cidr},gw=${var.gateway_ip}"
        : "ip=dhcp"
    )
  }

  # Toujours monitoring + scripts spécifiques par VM (normalisés, sans doublons)
  scripts_to_run = {
    for vm in var.vm_names :
    vm => compact(distinct(concat(
      var.default_monitoring_script_path != "" ? [replace(var.default_monitoring_script_path, "\\", "/")] : [],
      try([for p in var.scripts[vm] : replace(p, "\\", "/")], [])
    )))
  }

  # Matrice aplatie (1 entrée = 1 fichier à uploader)
  upload_matrix = flatten([
    for vm, lst in local.scripts_to_run : [
      for idx, p in lst : {
        key    = "${vm}-${idx + 1}"
        vm     = vm
        idx    = idx + 1
        path   = p
      }
    ]
  ])
}

resource "proxmox_vm_qemu" "vm" {
  for_each    = toset(var.vm_names)
  name        = each.value
  target_node = var.proxmox_node
  clone       = var.template_name
  full_clone  = true
  os_type     = "cloud-init"
  agent       = 1
  define_connection_info = true

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

# 📦 Upload de CHAQUE script (un null_resource par script)
resource "null_resource" "upload_script" {
  for_each = { for x in local.upload_matrix : x.key => x }

  depends_on = [proxmox_vm_qemu.vm]

  connection {
    type        = "ssh"
    host        = coalesce(
      try(proxmox_vm_qemu.vm[each.value.vm].ssh_host, null),
      try(proxmox_vm_qemu.vm[each.value.vm].default_ipv4_address, null)
    )
    port        = coalesce(try(proxmox_vm_qemu.vm[each.value.vm].ssh_port, null), 22)
    user        = var.cloudinit_user
    private_key = file(replace(var.ssh_private_key_path, "\\", "/"))
    timeout     = "2m"
  }

  provisioner "file" {
    source      = each.value.path
    destination = "/tmp/script_${each.value.idx}.sh"
  }
}

# ▶️ Écriture de l'INSTANCE_ID + exécution des scripts (un null_resource par VM)
resource "null_resource" "run_scripts" {
  for_each = { for vm, lst in local.scripts_to_run : vm => lst if length(lst) > 0 }

  depends_on = [
    proxmox_vm_qemu.vm,
    null_resource.upload_script
  ]

  triggers = {
    always_run = timestamp()
  }

  connection {
    type        = "ssh"
    host        = coalesce(
      try(proxmox_vm_qemu.vm[each.key].ssh_host, null),
      try(proxmox_vm_qemu.vm[each.key].default_ipv4_address, null)
    )
    port        = coalesce(try(proxmox_vm_qemu.vm[each.key].ssh_port, null), 22)
    user        = var.cloudinit_user
    private_key = file(replace(var.ssh_private_key_path, "\\", "/"))
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      # ✅ Stocke l'INSTANCE_ID dans /etc/instance-info.conf
      "sudo bash -c 'printf \"INSTANCE_ID=%s\\n\" \"${var.instance_id}\" > /etc/instance-info.conf'",
      "sudo bash -c 'printf \"DEPLOYED_AT=%s\\n\" \"$(date -Is)\" >> /etc/instance-info.conf'",
      "sudo chmod 0644 /etc/instance-info.conf",

      # Exposition de la variable pour les scripts
      "export INSTANCE_ID=${var.instance_id}",

      # CRLF -> LF + chmod + exécution avec INSTANCE_ID
      "for f in $(ls /tmp/script_*.sh 2>/dev/null | sort -V); do tr -d '\\r' < $f > $f.tmp && mv $f.tmp $f; chmod +x $f; sudo bash -c \"INSTANCE_ID=${var.instance_id} $f\"; done",

      "echo '✅ Fin des scripts avec INSTANCE_ID=${var.instance_id}'"
    ]
  }
}
