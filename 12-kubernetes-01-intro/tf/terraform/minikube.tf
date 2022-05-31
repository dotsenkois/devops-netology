resource "yandex_compute_instance" "minikube" {
name        = "minikube-node-01"
platform_id = var.yc_platform_id
zone        = var.yc_zone
hostname = "minikube-node-01"

  resources {
    core_fraction = 20
    cores  = 2
    memory = 6
  }

  boot_disk {
    initialize_params {
      image_id = var.yc_image_id
      size = 15
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.minikube-subnet-1.id
    ip_address = var.yc_instances_sn["minikube-node-01"]
    nat       = "true"
  }

  metadata = {
    user-data = file("${path.module}/cloud_config.yaml")
    #ssh-keys = "dotsenkois:${file("~/.ssh/id_rsa.pub")}"
  }

  scheduling_policy {
    preemptible = true
  }
}
