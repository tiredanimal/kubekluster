variable "ssh_public_key" {
  type        = string
  description = "Your SSH public key used to ssh to the hosts"
}

variable "controller_count" {
  type        = number
  description = "Number of controllers"
  default     = 1
}

variable "worker_count" {
  type        = number
  description = "Number of workers"
  default     = 2
}

variable "controller_memory" {
  type        = number
  description = "RAM in MB for each controller"
  default     = 2048
}

variable "worker_memory" {
  type        = number
  description = "RAM in MB for each worker"
  default     = 2048
}
