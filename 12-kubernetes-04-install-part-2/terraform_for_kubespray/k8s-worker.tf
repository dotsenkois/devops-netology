resource "yandex_compute_instance" "worker" {
  for_each    = var.yc_instances_workers
  name        = each.key
  hostname    = each.key
  platform_id = var.yc_platform_id
  zone        = var.yc_zone

  resources {
    core_fraction = var.workers_resources.core_fraction
    cores         = var.workers_resources.cores
    memory        = var.workers_resources.memory
  }

  boot_disk {
    initialize_params {
      image_id = var.yc_image_id
      size     = var.workers_resources.boot_disk_size
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
