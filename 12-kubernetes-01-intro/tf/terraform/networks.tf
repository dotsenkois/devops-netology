resource "yandex_vpc_network" "minikube-network-1" {
  name = "minikube"
}

resource "yandex_vpc_subnet" "minikube-subnet-1" {
  name       = "minikube-subnet1"
  zone       = "ru-central1-c"
  network_id = yandex_vpc_network.minikube-network-1.id
  v4_cidr_blocks = ["10.130.0.0/24"]
}