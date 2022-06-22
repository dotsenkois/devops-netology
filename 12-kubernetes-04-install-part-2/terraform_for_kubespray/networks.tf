resource "yandex_vpc_network" "k8s-network-1" {
  name = "k8s"
}

resource "yandex_vpc_subnet" "k8s-subnet-1" {
  name           = "k8s-subnet1"
  zone           = "ru-central1-c"
  network_id     = yandex_vpc_network.k8s-network-1.id
  v4_cidr_blocks = ["10.130.0.0/24"]
}