
variable "yc_zone" {
  type    = string
  default = "ru-central1-c"
}

variable "yc_instances_control-plane" {
  type = map(any)
  default = {
    "control-plane-node-01" = "10.130.0.20"
  }
}

variable "yc_instances_workers" {
  type = map(any)
  default = {
    "worker-node-01" = "10.130.0.51"
    "worker-node-02" = "10.130.0.52"
    # "worker-node-03" = "10.130.0.53"
  }
}

variable "control-plane_resources" {
  type = map(any)
  default = {
    "core_fraction"  = 20
    "cores"          = 2
    "memory"         = 6
    "boot_disk_size" = 15
  }
}

variable "workers_resources" {
  type = map(any)
  default = {
    "core_fraction"  = 20
    "cores"          = 2
    "memory"         = 4
    "boot_disk_size" = 15
  }
}

variable "yc_platform_id" {
  type    = string
  default = "standard-v1"
}
variable "yc_image_id" {
  type    = string
  default = "fd8ciuqfa001h8s9sa7i"
}

variable "HostsPath" {
  type    = string
  default = "../playbook/inventory/prod/hosts.yml"

}