
output "vmid" {
  value = proxmox_virtual_environment_container.this.vm_id
}

output "hostname" {
  value = var.name
}

output "ip" {
  value = var.ip
}
