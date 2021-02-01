terraform {
  required_version = ">= 0.14"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.3"
    }
  }
}

locals {
  controllers = {
    memory = "2048"
    count  = 3
  }
  workers = {
    memory = "4096"
    count  = 3
  }
  ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDy6EgOgmiyjhTQqVNDmqVF1u0ahvQUOf1zvgGaIDRMk matt@manjaro"
}

# instance the provider
provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_pool" "cluster" {
  name = "cluster"
  type = "dir"
  path = "/var/lib/libvirt/kubekluster_pool"
}

resource "libvirt_volume" "debian" {
  name   = "debian10"
  pool   = libvirt_pool.cluster.name
  source = "${abspath(path.module)}/debian10.qcow2"
  format = "qcow2"
}

module "controllers" {
  source = "./modules/node"

  memory         = "2048"
  number         = 1
  name_prefix    = "control"
  network_offset = 16

  ssh_public_key = local.ssh_public_key

  storage_pool_name = libvirt_pool.cluster.name
  base_volume_id    = libvirt_volume.debian.id
  size              = 8 * 1024 * 1024 * 1024
}

module "workers" {
  source = "./modules/node"

  memory         = "2048"
  number         = 2
  name_prefix    = "worker"
  network_offset = 32

  ssh_public_key = local.ssh_public_key

  storage_pool_name = libvirt_pool.cluster.name
  base_volume_id    = libvirt_volume.debian.id
  size              = 8 * 1024 * 1024 * 1024
}