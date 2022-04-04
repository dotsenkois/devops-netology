
variable "yc_zone" {
  type    = string
  default = "ru-central1-c"
}

variable "yc_instances_sn" {
  type = map
  default = {
    "jenkins-master"  = "10.130.0.10"
    "jenkins-agent" = "10.130.0.11"
  }
}


# variable "yc_instances_nginx" {
#   type = map
#   default = {
#     "nginx-node01"  = "10.130.0.50"
#   }
# }

# variable "yc_instances_ansible" {
#   type = map
#   default = {
#     "ansible-node01"  = "10.130.0.100"
#   }
# }



variable "yc_platform_id" {
  type = string
  default = "standard-v1"
}
variable "yc_image_id" {
  type = string
  default = "fd8p7vi5c5bbs2s5i67s"
}
