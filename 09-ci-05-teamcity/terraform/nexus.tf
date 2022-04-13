resource "yandex_compute_instance" "nexus" {
name        = "nexus-${var.VM_name_generate["lesson"]}"
platform_id = var.yc_platform_id
zone        = var.yc_zone
hostname = "nexus"

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
    subnet_id = yandex_vpc_subnet.subnet.id
    ip_address = var.yc_instances_sn["nexus"]
    nat       = "true"
  }

  metadata = {
    ssh-keys = "dotsenkois:${file("/home/dotsenkois/.ssh/id_rsa.pub")}"
    user-data = file("${path.module}/cloud_config.yaml")
  }

  scheduling_policy {
    preemptible = true
  }
}
