variable "yc_zone" {
  type    = string
  default = "ru-central1-a"
}

variable "yc_folder" {
  type    = string
  default = "b1gg2r2bur6u5horho3b"
}

variable "yc_instances_sn" {
  type = map
  default = {
    "teamcity-server"   = "10.130.0.10"
    "teamcity-agent"    = "10.130.0.11"
    "nexus"             = "10.130.0.12"
  }
}

variable "yc_platform_id" {
  type = string
  default = "standard-v1"
}

variable "yc_image_id" {
  type = string
  default = "fd8p7vi5c5bbs2s5i67s"
}

variable "teamcity-images" {
  type = map
  default = {
    "server" = "jetbrains/teamcity-server"
    "agent" = "jetbrains/teamcity-agent"    
    }
}

variable "VM_name_generate" {
  type = map
  default = {
    "school" = "Netology"
    "groupe" = "MNT-11"
    "lesson" = "09-ci-05-teamcity"
  }
}