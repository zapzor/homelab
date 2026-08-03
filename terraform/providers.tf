provider "proxmox" {
  endpoint  = var.proxmox_host
  api_token = var.proxmox_api_token
  insecure  = true
}
