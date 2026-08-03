variable "proxmox_host" {
  description = "IP address of the Proxmox node"
  type        = string
}

variable "proxmox_api_token" {
  description = "Proxmox API token"
  type        = string
  sensitive   = true
}
