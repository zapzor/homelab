# This file defines local variables for the Terraform configuration.
locals {
  containers = yamldecode(file("${path.module}/containers.yaml"))
}
