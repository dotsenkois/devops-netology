resource "yandex_compute_instance" "nat" {
  name        = "nat"
  hostname = "nat"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd83slullt763d3lo57m"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.k8s-private-zone-a.id
    nat       = true
  }

  metadata = {
    user-data = file("${path.module}/cloud_config.yaml")
  }

  scheduling_policy {
    preemptible = "true"
  }
}

resource "yandex_vpc_route_table" "lab-rt-a" {
  name       = "route-table"
  network_id = yandex_vpc_network.k8s-network.id  
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = yandex_compute_instance.nat.network_interface.0.ip_address
  }
}

