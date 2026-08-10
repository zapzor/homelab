# This creates the defined LXC container
resource "proxmox_virtual_environment_container" "this" {
  node_name    = var.node
  vm_id        = var.vmid
  unprivileged = var.unprivileged

  initialization {
    hostname = var.name

    ip_config {
      ipv4 {
        address = "dhcp"
      }
      ipv6 {
        address = "dhcp"
      }
    }

  }
  cpu {
    cores     = var.cores
    architecture = "amd64"
    limit    = 0
  }

  network_interface {
    name = "eth0"
    bridge = "vmbr0"
    enabled = true
    firewall = false
    host_managed = false
    mtu = 0
    rate_limit = 0
    vlan_id = 0
  }

  memory {
    dedicated = var.memory
    swap = 0
  }

  disk {
    datastore_id = "local-lvm"
    size         = var.size
  }

  console {
    enabled   = true
    tty_count = 2
    type      = "tty"
}

  features {
    fuse = false
    keyctl = var.keyctl
    mknod = false
    mount = []
    nesting = true
  }

  operating_system {
    template_file_id = "local:vztmpl/debian-13-standard_13.6-1_amd64.tar.zst"
    type             = "debian"
  }

  lifecycle {
    ignore_changes = [
      operating_system,
      mount_point,
      environment_variables
    ]
  }
}
