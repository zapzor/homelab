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
  password   = var.container_password
}
