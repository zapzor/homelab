locals {
  containers = {
    pihole = {
      vmid   = 150
      cores  = 1
      memory = 512
      size   = 8
      ip     = "192.168.1.10/24"
    }

    grafana = {
      vmid   = 151
      cores  = 2
      memory = 1024
      size   = 16
      ip     = "192.168.1.11/24"
    }

  }
}
