locals {
  containers = yamldecode(file("${path.module}/containers.yaml"))
}
