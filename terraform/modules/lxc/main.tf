# This module creates a Proxmox LXC container.

resource "proxmox_virtual_environment_container" "this" {
  node_name    = var.node
  vm_id        = var.vmid
  description  = var.name
  unprivileged = true
  started      = false

  initialization {
    hostname = var.name

    ip_config {
      ipv4 {
        address = var.ip
        gateway = var.gateway
      }
    }

    user_account {
      password = var.password
    }
  }

  cpu {
    cores = var.cores
  }

  memory {
    dedicated = var.memory
  }

  disk {
    datastore_id = var.storage
    size         = var.rootfs_size
  }

  network_interface {
    name   = "eth0"
    bridge = var.bridge
  }

  operating_system {
    template_file_id = var.ostemplate
  }

  features {
    nesting = true
  }
}
