variable "name" {
  type = string
}

variable "vmid" {
  type = number
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
}

variable "ostemplate" {
  type = string
}

variable "password" {
  type      = string
  sensitive = true
}
