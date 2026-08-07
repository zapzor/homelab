variable "container_password" {
  type      = string
  sensitive = true
  default   = "password123"
}
variable "node" {
  type    = string
  default = "pve"
}

variable "bridge" {
  type    = string
  default = "vmbr0"
}

variable "storage" {
  type    = string
  default = "local-lvm"
}

variable "gateway" {
  type    = string
  default = "10.99.0.1"
}

variable "ostemplate" {
  type    = string
  default = "local:vztmpl/debian-13-standard_13.6-1_amd64.tar.zst"
}
