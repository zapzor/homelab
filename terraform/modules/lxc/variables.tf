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

variable "size" {
  type = number
}

variable "os_type" {
  type    = string
}

variable "unprivileged" {
  type    = bool
}

variable "keyctl" {
  type = bool
}

variable "mount_points" {
  type = list(object({
    size   = optional(string)
    volume = string
    path   = string
  }))

  default = []
}
