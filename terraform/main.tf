resource "proxmox_virtual_environment_container" "test" {
  node_name = "pve"
  vm_id     = 999
  operating_system {
    type             = "debian"
    template_file_id = "local:vztmpl/debian-13-standard_13.1-2_amd64.tar.zst.tmp_dwnl.435394"
  }
}
