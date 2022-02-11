# data "yandex_compute_instance" "ansible-test-01" {
#   name = "ansible-test-01"
# }

# output "instance_external_ip" {
#   value = "${data.yandex_compute_instance.ansible-test-01.network_interface.0.nat_ip_address}"
# }