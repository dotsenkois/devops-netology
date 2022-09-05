
variable "yc_zone" {
  type    = string
  default = "ru-central1-a"
}

variable "yc_folder_id" {
  type    = string
  default = "b1gu66bs3cl0mkeh2ucf"
}

variable "nat-gateway" {
  type = map(any)
  default = {
    name= "nat-gateway"
    core_fraction  = 20
    cores          = 2
    memory         = 2
    boot_disk_size = 15
    image_id = "fd8q9r5va9p64uhch83k"
    type     = "network-hdd"
    size     = 15
    preemptible = "false"
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
  default = "../../../kubespray/inventory/mycluster/inventory.yml" #"../playbook/inventory/prod/hosts.yml"

}


