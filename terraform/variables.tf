# Some global variables for Terraform

variable "bridge" {
  type    = string
  default = "vmbr0"
}

variable "storage" {
  type    = string
  default = "local-lvm"
}

variable "node" {
  type = string
  default = "amaterasu"
}
