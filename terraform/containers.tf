# This calls the lxc module for each container defined in the containers.yaml file

import {
  for_each = local.containers
  to       = module.lxc[each.key].proxmox_virtual_environment_container.this
  id       = "${var.node}/${each.value.vmid}"
}

module "lxc" {
  source   = "./modules/lxc"
  for_each = local.containers

  name        = each.key
  vmid        = each.value.vmid
  cores       = each.value.cores
  memory      = each.value.memory
  rootfs_size = each.value.size
  ip          = each.value.ip

  node       = var.node
  bridge     = var.bridge
  storage    = var.storage
  gateway    = var.gateway
  ostemplate = var.ostemplate
  #password   = var.container_password
}
