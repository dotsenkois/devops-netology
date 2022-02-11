
provider "yandex" {
  zone = "ru-central1-c"
  #Ключи сохранены в переменых среды:
  #YC_TOKEN, YC_CLOUD_ID, YC_FOLDER_ID
}

locals {
  web_instance_type_map = {
    stage = "standard-v1"
    prod  = "standard-v1"
  }
  web_instance_count_map = {
    stage = 1
    prod  = 2
  }
  web_instance_name_map = {
    stage = "ELK"
    prod  = "ELK"
  }
  instances = {
    "standard-v1" = "fd89c9t0duap8opetfb9"
    "standard-v2" = "fd89c9t0duap8opetfb9"
  }
}

resource "yandex_compute_instance" "ansible-test" {
  for_each = local.instances
  platform_id = each.key

  # name        = "ansible-test-01"
  # hostname    = "ansible-test-01"
  # description = "test vm for netology"

  resources {
    cores         = "2"
    memory        = "2"
    core_fraction = "20"
  }
  boot_disk {
    initialize_params {
      image_id = "fd89c9t0duap8opetfb9"
      type     = "network-hdd"
      size     = "10"
    }
  }
  network_interface {
    subnet_id = "b0cgoir8ev0gjdgfn8ko"
    nat       = "true"
  }
  metadata = {
    user-data = file("${path.module}/cloud_config.yaml")
    }
  scheduling_policy {
    preemptible = "true"
  }
}

