output "containers" {
  value = {
    for name, mod in module.lxc : name => {
      vmid     = mod.vmid
      hostname = mod.hostname
      ip       = mod.ip
    }
  }
}
