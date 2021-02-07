variable "name_prefix" {
  type        = string
  description = "Prefix to use for vm names"
}

variable "vcpu" {
  type        = string
  description = "Number of vCPUs"
  default     = 2
}

variable "memory" {
  type        = string
  description = "Memory in MB"
  default     = "2048"
}

variable "number" {
  type        = number
  description = "Number of this type of nodes"
}

variable "size" {
  type        = number
  description = "Disk size in bytes"
  default     = null
}

variable "network_prefix" {
  type        = string
  description = "Starting 3 octets of the /24 the VMs will be provisioned into"
  default     = "192.168.33"
}

variable "network_offset" {
  type        = number
  description = "Offset to start of first IP for host"
}

variable "nameserver_offset" {
  type        = number
  default     = 1
  description = "4th octet of nameserver ip"
}

variable "gateway_offset" {
  type        = number
  description = "4th octet of gateway ip"
  default     = 1
}

variable "ssh_public_key" {
  type        = string
  description = "SSH Public key to use for access to the debian user"
}

variable "base_volume_id" {
  type        = string
  description = "OS disk volume to use as QCOW base"
}

variable "storage_pool_name" {
  type        = string
  description = "Storage pool for disk images"
}
