# Создать VPC.
## Используя vpc-модуль terraform, создать пустую VPC с подсетью 172.31.0.0/16.
## Выбрать регион и зону. 

resource "yandex_vpc_network" "empty-network" {
  name = "empty-network"
}

# Публичная сеть.

## Создать в vpc subnet с названием public, сетью 172.31.32.0/19 и Internet gateway.

resource "yandex_vpc_subnet" "public" {
  v4_cidr_blocks = ["172.31.32.0/19"]
  zone           = "ru-central1-a"
  network_id  = yandex_vpc_network.empty-network.id
}

## Добавить RouteTable, направляющий весь исходящий трафик в Internet gateway.
## Создать в этой приватной сети виртуалку с публичным IP и подключиться к ней, убедиться что есть доступ к интернету.

resource "yandex_compute_instance" "public" {
  name        = "public"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"

  hostname = "public"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8uoiksr520scs811jl"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat = true
  }

  metadata = {
    user-data = file("${path.module}/cloud_config.yaml")
  }
  scheduling_policy {
    preemptible = "true"
  }
}



# Приватная сеть.

## Создать в vpc subnet с названием private, сетью 172.31.96.0/19.

resource "yandex_vpc_subnet" "private" {
  v4_cidr_blocks = ["172.31.96.0/19"]
  zone           = "ru-central1-a"
  network_id =  yandex_vpc_network.empty-network.id
# привязка таблицы маршрутизации к подсети обязательна
  route_table_id = yandex_vpc_route_table.lab-rt-a.id
}

# Добавить NAT gateway в public subnet.

resource "yandex_compute_instance" "nat" {
  name        = "nat"
  hostname = "nat"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd83slullt763d3lo57m"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
  }

  metadata = {
    user-data = file("${path.module}/cloud_config.yaml")
  }

  scheduling_policy {
    preemptible = "true"
  }
}

# Добавить Route, направляющий весь исходящий трафик private сети в NAT.

resource "yandex_vpc_route_table" "lab-rt-a" {
  name       = "route-table"
  network_id = yandex_vpc_network.empty-network.id  
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = yandex_compute_instance.nat.network_interface.0.ip_address
  }
}

# проверка точки узла, через который происходит связь с интерент 
# https://cloud.yandex.ru/docs/tutorials/routing/nat-instance
# curl ifconfig.co на узле в приватной сети

# VPN

resource "yandex_compute_instance" "private" {
  name        = "private"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"
  hostname = "private"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8uoiksr520scs811jl"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.private.id}"
  }

  metadata = {
    user-data = file("${path.module}/cloud_config.yaml")
  }
  scheduling_policy {
    preemptible = "true"
  }
}

#VPN

resource "yandex_vpc_address" "open-VPN" {
  name = "open-VPN"
  external_ipv4_address {
    zone_id = "ru-central1-a"
    
  }
}

# resource "yandex_vpc_security_group" "open-VPN" {
#   name        = "open-VPN"
#   description = "Description for security group"
#   network_id  = "${yandex_vpc_network.empty-network.id}"

#   ingress {
#     protocol       = "TCP"
#     description    = "VPN Server"
#     v4_cidr_blocks = ["0.0.0.0/0"]
#     port           = 443
#   }

#   ingress {
#     protocol       = "UDP"
#     description    = "VPN Server"
#     v4_cidr_blocks = ["0.0.0.0/0"]
#     port           = 1194
#   }

#     ingress {
#     protocol       = "UDP"
#     description    = "Admin Web UI, Client Web UI"
#     v4_cidr_blocks = ["0.0.0.0/0"]
#     port           = 943
#   }

# }

# To login please use the "openvpn" account with "cqxKvXIsBs71" password.

resource "yandex_compute_instance" "VPN" {
  name        = "open"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8e6a9c1klmji7decok"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.private.id}"
    nat = true
  }

  metadata = {
    user-data = file("${path.module}/cloud_config.yaml")
  }
  scheduling_policy {
    preemptible = "true"
  }
}