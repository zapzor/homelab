# Imports containers added from outside of Terraform.
import {
 for_each = local.containers
 to       = module.lxc[each.key].proxmox_virtual_environment_container.this
 id       = "${var.node}/${each.value.vmid}"
}

# This calls the lxc module for each container defined in the containers.yaml file
module "lxc" {
  source   = "./modules/lxc"
  for_each = local.containers

  name         = each.key
  vmid         = each.value.vmid
  cores        = each.value.cores
  memory       = each.value.memory
  size         = each.value.size
  unprivileged = try(each.value.unprivileged, true)
  keyctl       = try(each.value.keyctl, true)

  node       = var.node
  os_type    = "debian"
}
