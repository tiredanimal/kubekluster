terraform {
  required_version = ">= 0.14"
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "0.6.3"
    }
  }
}

resource "libvirt_cloudinit_disk" "this" {
  count = var.number
  name = format("%s-cloud-init-%d.iso",var.name_prefix,count.index+1)
  user_data = var.user_data
  network_config = templatefile("${path.module}/network_config.yaml", {
    network_addr  = format("%s.%d/24",var.network_prefix,var.network_offset+count.index)
    gateway_ip    = format("%s.%d",var.network_prefix,var.gateway_offset),
    nameserver_ip = format("%s.%d",var.network_prefix,var.nameserver_offset)
  })
  pool = var.storage_pool_name
}

resource "libvirt_volume" "os" {
  count = var.number
  name   = format("%s%d-os", var.name_prefix, count.index+1)
  pool   = var.storage_pool_name
  source = var.volume_source_path
  format = "qcow2"
}

# Create the machine
resource "libvirt_domain" "nodes" {
  count = var.number
  name = format("%s%d", var.name_prefix, count.index+1)
  memory = var.memory
  vcpu = var.vcpu

  cloudinit = libvirt_cloudinit_disk.this[count.index].id

  qemu_agent = false

  network_interface {
    network_name = "default"
  }

  console {
    type = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  disk {
    volume_id = libvirt_volume.os[count.index].id
  }

  graphics {
    type = "spice"
    listen_type = "address"
    autoport = true
  }
}