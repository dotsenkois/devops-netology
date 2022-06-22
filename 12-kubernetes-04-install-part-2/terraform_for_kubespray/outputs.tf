# data "yandex_compute_instance" "elk" {
#   name = "elk"
# }

# output "instance_external_ip" {
#   value = "${data.yandex_compute_instance.elk.network_interface.0.nat_ip_address}"
# }