# This creates the defined LXC container
resource "proxmox_virtual_environment_container" "this" {
  node_name    = var.node
  vm_id        = var.vmid
  unprivileged = var.unprivileged

  initialization {
    hostname = var.name

    ip_config {
      ipv4 {
        address = var.ip
        gateway = var.gateway
      }
    }

  }
  cpu {
    cores        = var.cores
  }

  memory {
    dedicated = var.memory
  }

  disk {
    datastore_id = var.storage
    size         = var.rootfs_size
  }

  operating_system {
    template_file_id = var.ostemplate
    type             = var.ostemplate == null ? var.os_type : null
  }

  lifecycle {
    ignore_changes = [
      environment_variables,
      operating_system,
      description,
      tags,
      mount_point,
      features,
      disk,
      initialization,
      console,
      #cpu,
      network_interface
    ]
  }
}
