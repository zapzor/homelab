variable "name" {
  type = string
}

variable "vmid" {
  type     = number
  nullable = true
}

variable "node" {
  type = string
}

variable "cores" {
  type = number
}

variable "memory" {
  type = number
}


variable "rootfs_size" {
  type = number
}

variable "storage" {
  type = string
}

variable "bridge" {
  type = string
}

variable "ip" {
  type = string
}

variable "gateway" {
  type = string
  default = "dhcp"
}

variable "ostemplate" {
  type    = string
  default = null
}

variable "os_type" {
  type    = string
}
variable "unprivileged" {
  type    = bool
}
