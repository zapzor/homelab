locals {
  containers = {

    wireguard = {
      vmid   = 2100
      cores  = 1
      memory = 512
      size   = 8
      ip     = "10.99.0.11/24"
    }

    mediaserver = {
      vmid   = 2101
      cores  = 2
      memory = 4096
      size   = 8
      ip     = "10.99.0.12/24"
    }

    postgresql = {
      vmid   = 2103
      cores  = 1
      memory = 1024
      size   = 8
      ip     = "10.99.0.14/24"
    }
    homepage = {
      vmid   = 2104
      cores  = 2
      memory = 1024
      size   = 8
      ip     = "10.99.0.15/24"
    }

    docker = {
      vmid   = 2110
      cores  = 2
      memory = 2048
      size   = 8
      ip     = "10.99.0.20/24"
    }
    pihole = {
      vmid   = 2111
      cores  = 2
      memory = 512
      size   = 8
      ip     = "10.99.0.21/24"
    }
    changedetection = {
      vmid   = 2112
      cores  = 4
      memory = 4096
      size   = 8
      ip     = "10.99.0.22/24"
    }

    caliweb = {
      vmid   = 2113
      cores  = 2
      memory = 2048
      size   = 8
      ip     = "10.99.0.23/24"
    }

    grafana = {
      vmid   = 2114
      cores  = 1
      memory = 512
      size   = 8
      ip     = "10.99.0.24/24"
    }

    commafeed = {
      vmid   = 2115
      cores  = 2
      memory = 2048
      size   = 8
      ip     = "10.99.0.25/24"
    }

    audiobookshelf = {
      vmid   = 2116
      cores  = 2
      memory = 2048
      size   = 8
      ip     = "10.99.0.26/24"
    }

    prometheus = {
      vmid   = 2117
      cores  = 1
      memory = 2048
      size   = 8
      ip     = "10.99.0.27/24"
    }

    terraform = {
      vmid   = 2118
      cores  = 1
      memory = 512
      size   = 8
      ip     = "10.99.0.28/24"
    }
    prometheus-pve-exporter = {
      vmid   = 2119
      cores  = 1
      memory = 512
      size   = 8
      ip     = "10.99.0.29/24"
    }

    ollama = {
      vmid   = 2120
      cores  = 4
      memory = 4096
      size   = 8
      ip     = "10.99.0.30/24"
    }

    frigate = {
      vmid   = 2121
      cores  = 4
      memory = 2048
      size   = 8
      ip     = "10.99.0.31/24"
    }

    mqtt = {
      vmid   = 2122
      cores  = 1
      memory = 512
      size   = 8
      ip     = "10.99.0.32/24"
    }

    invidious = {
      vmid   = 2123
      cores  = 2
      memory = 4096
      size   = 8
      ip     = "10.99.0.33/24"
    }

    nexterm = {
      vmid   = 2124
      cores  = 2
      memory = 2048
      size   = 8
      ip     = "10.99.0.34/24"
    }

    authelia = {
      vmid   = 2126
      cores  = 1
      memory = 512
      size   = 8
      ip     = "10.99.0.35/24"
    }

    loki = {
      vmid   = 2127
      cores  = 1
      memory = 512
      size   = 8
      ip     = "10.99.0.36/24"
    }

    vikunja = {
      vmid   = 2128
      cores  = 1
      memory = 1024
      size   = 8
      ip     = "10.99.0.37/24"
    }

    ansible = {
      vmid   = 2130
      cores  = 1
      memory = 512
      size   = 8
      ip     = "10.99.0.39/24"
    }

    proxmox-backup-server = {
      vmid   = 2131
      cores  = 2
      memory = 2048
      size   = 8
      ip     = "10.99.0.40/24"
    }

    gramps-web = {
      vmid   = 2133
      cores  = 2
      memory = 4096
      size   = 8
      ip     = "10.99.0.41/24"
    }

    traefik = {
      vmid   = 2134
      cores  = 1
      memory = 512
      size   = 8
      ip     = "10.99.0.42/24"
    }
    tailscale = {
      vmid   = 2135
      cores  = 2
      memory = 2048
      size   = 8
      ip     = "10.99.0.43/24"
    }
    openbao = {
      vmid   = 2136
      cores  = 1
      memory = 1024
      size   = 8
      ip     = "10.99.0.44/24"
    }
    code-server = {
      vmid   = 2137
      cores  = 4
      memory = 2048
      size   = 8
      ip     = "10.99.0.45/24"
    }

  }

}
