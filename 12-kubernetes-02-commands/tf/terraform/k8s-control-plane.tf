resource "yandex_compute_instance" "control-plane" {
  for_each    = var.yc_instances_control-plane
  name        = each.key
  hostname    = each.key
  platform_id = var.yc_platform_id
  zone        = var.yc_zone

  resources {
    core_fraction = var.control-plane_resources.core_fraction
    cores         = var.control-plane_resources.cores
    memory        = var.control-plane_resources.memory
  }

  boot_disk {
    initialize_params {
      image_id = var.yc_image_id
      size     = var.control-plane_resources.boot_disk_size
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.k8s-subnet-1.id
    ip_address = each.value
    nat        = "true"
  }

  metadata = {
    user-data = file("${path.module}/cloud_config.yaml")
    # ssh-keys = "dotsenkois:${file("/home/dotsenkois/.ssh/id_rsa.pub")}"
  }

  scheduling_policy {
    preemptible = true
  }
}
