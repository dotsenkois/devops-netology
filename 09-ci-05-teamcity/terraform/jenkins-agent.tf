resource "yandex_compute_instance" "jenkins-agent" {
name        = "jenkins-agent"
platform_id = var.yc_platform_id
zone        = var.yc_zone
hostname = "jenkins-agent"

  resources {
    core_fraction = 20
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = var.yc_image_id

    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    ip_address = var.yc_instances_sn["jenkins-agent"]
    nat       = "true"
  }

  metadata = {
    user-data = file("${path.module}/cloud_config.yaml")
  }

  scheduling_policy {
    preemptible = true
  }
}
