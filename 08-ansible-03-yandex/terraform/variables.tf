
variable "yc_zone" {
  type    = string
  default = "ru-central1-c"
}

variable "yc_instances_list" {
  type = map
  default = {
    "es-node01"  = "10.130.0.10"
    "kib-node01" = "10.130.0.11"
    "app-node01" = "10.130.0.20"
    "app-node02" = "10.130.0.21"
  }
}

variable "yc_platform_id" {
  type = string
  default = "standard-v1"
}
variable "yc_image_id" {
  type = string
  default = "fd89c9t0duap8opetfb9"
}
