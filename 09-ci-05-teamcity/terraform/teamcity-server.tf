resource "yandex_compute_instance" "teamcity-server" {
name        = "teamcity-server-${var.VM_name_generate["lesson"]}"
platform_id = var.yc_platform_id
zone        = var.yc_zone
hostname = "teamcity-server"

  resources {
    core_fraction = 20
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.coi.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    ip_address = var.yc_instances_sn["teamcity-server"]
    nat       = "true"
  }

  metadata = {
    ssh-keys = "dotsenkois:${file("/home/dotsenkois/.ssh/id_rsa.pub")}"
    user-data = file("${path.module}/cloud_config.yaml")
    docker-container-declaration = file("${path.module}/teamcity-server_declaration.yaml")
  }

  scheduling_policy {
    preemptible = true
  }
}
