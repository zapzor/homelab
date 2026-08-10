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

variable "ip" {
  type = string
}

variable "gateway" {
  type = string
  default = "dhcp"
}

# variable "os_template" {
#   type = string
# }

variable "os_type" {
  type    = string
}

variable "unprivileged" {
  type    = bool
}
