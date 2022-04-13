resource "yandex_vpc_network" "network" {
  name = "network-${var.VM_name_generate["school"]}-${var.VM_name_generate["groupe"]}-${var.VM_name_generate["lesson"]}"
}

resource "yandex_vpc_subnet" "subnet" {
  name       = "subnet-${var.VM_name_generate["school"]}-${var.VM_name_generate["groupe"]}-${var.VM_name_generate["lesson"]}"
  zone       = var.yc_zone
  network_id = yandex_vpc_network.network.id
  v4_cidr_blocks = ["10.130.0.0/24"]
}