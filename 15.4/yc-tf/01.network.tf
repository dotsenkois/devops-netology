resource "yandex_vpc_network" "db-network" {
  name = "db-network"
}

resource "yandex_vpc_subnet" "db-zone-a" {
  v4_cidr_blocks = ["172.31.96.0/24"]
  zone           = "ru-central1-a"
  network_id =  yandex_vpc_network.db-network.id
}

resource "yandex_vpc_subnet" "db-zone-b" {
  v4_cidr_blocks = ["172.31.97.0/24"]
  zone           = "ru-central1-b"
  network_id =  yandex_vpc_network.db-network.id
}


