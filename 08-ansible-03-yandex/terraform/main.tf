
provider "yandex" {
  zone = "ru-central1-c"
  #Ключи сохранены в переменых среды:
  #YC_TOKEN, YC_CLOUD_ID, YC_FOLDER_ID
}

resource "yandex_compute_instance" "elk" {
for_each = var.yc_instances_list
name        = each.key
platform_id = var.yc_platform_id
zone        = var.yc_zone

  resources {
    core_fraction = 20
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.yc_image_id
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet-1.id}"
    ip_address = each.value
    nat       = "true"
  }

  metadata = {
    user-data = file("${path.module}/cloud_config.yaml")
  }

  scheduling_policy {
    preemptible = true
  }
}


resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name       = "subnet1"
  zone       = "ru-central1-c"
  network_id = "${yandex_vpc_network.network-1.id}"
  v4_cidr_blocks = ["10.130.0.0/24"]
}