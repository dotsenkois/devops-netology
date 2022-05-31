
variable "yc_zone" {
  type    = string
  default = "ru-central1-c"
}

variable "yc_instances_sn" {
  type = map
  default = {
    "minikube-node-01" = "10.130.0.50"
  }
}

variable "yc_platform_id" {
  type = string
  default = "standard-v1"
}
variable "yc_image_id" {
  type = string
  default = "fd8ciuqfa001h8s9sa7i"
}
