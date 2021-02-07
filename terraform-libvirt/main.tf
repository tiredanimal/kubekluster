terraform {
  required_version = ">= 0.14"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.3"
    }
  }
}

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

  memory         = tostring(var.controller_memory)
  number         = var.controller_count
  name_prefix    = "control"
  network_offset = 16

  ssh_public_key = var.ssh_public_key

  storage_pool_name = libvirt_pool.cluster.name
  base_volume_id    = libvirt_volume.debian.id
  size              = 8 * 1024 * 1024 * 1024
}

module "workers" {
  source = "./modules/node"

  memory         = tostring(var.worker_memory)
  number         = var.worker_count
  name_prefix    = "worker"
  network_offset = 32

  ssh_public_key = var.ssh_public_key

  storage_pool_name = libvirt_pool.cluster.name
  base_volume_id    = libvirt_volume.debian.id
  size              = 8 * 1024 * 1024 * 1024
}
