## Задание 1. Создать bucket S3 и разместить там файл с картинкой.

resource "yandex_iam_service_account" "bucket-sa" {
  name      = "bucket-sa-1"
}

// Назначение роли сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = var.yc_folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.bucket-sa.id}"
}

// Создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.bucket-sa.id
  description        = "static access key for bucket-sa object storage"
}

// Создание бакета с использованием ключа
resource "yandex_storage_bucket" "bucket-for-web" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = "15.2-dotsenkois-2"
  acl    = "public-read"


  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  anonymous_access_flags {
    read = true
    list = false
  }
}
#  Положить в bucket файл с картинкой

resource "yandex_storage_object" "test-object" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = yandex_storage_bucket.bucket-for-web.id
  key        = "wallpaper.jpeg"
  source     = "${path.module}/jammy-jellyfish-wallpaper.jpeg"
}

# создание статического сайта

resource "yandex_storage_object" "index" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = yandex_storage_bucket.bucket-for-web.id
  key        = "index.html"
  source     = "${path.module}/bucket-site/index.html"
}

resource "yandex_storage_object" "error" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = yandex_storage_bucket.bucket-for-web.id
  key        = "error.html"
  source     = "${path.module}/bucket-site/error.html"
}



# Группа инстансев

resource "yandex_iam_service_account" "ig-sa" {
  name        = "ig-sa"
  description = "service account to manage IG"
}

resource "yandex_resourcemanager_folder_iam_binding" "editor" {
  folder_id = var.yc_folder_id
  role      = "editor"
  members   = [
    "serviceAccount:${yandex_iam_service_account.ig-sa.id}",
  ]
  depends_on = [
    yandex_iam_service_account.ig-sa,
  ]
}

resource "yandex_compute_instance_group" "ig-2" {
  name               = "fixed-ig-1"
  folder_id          = var.yc_folder_id
  service_account_id = "${yandex_iam_service_account.ig-sa.id}"
  depends_on          = [yandex_resourcemanager_folder_iam_binding.editor]
  instance_template {
    platform_id = "standard-v1"
    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd827b91d99psvq5fjit"
      }
    }

    network_interface {
      network_id = "${yandex_vpc_network.network-1.id}"
      subnet_ids = ["${yandex_vpc_subnet.subnet-1.id}"]
    }

    metadata = {
      user-data = file("${path.module}/cloud_config.yaml")
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = ["ru-central1-a"]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion = 0
  }
  load_balancer {
    target_group_name        = "target-group"
    target_group_description = "load balancer target group"
  }

  
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.network-1.id}"
  v4_cidr_blocks = ["192.168.10.0/24"]
}

# Создать сетевой балансировщик



resource "yandex_lb_network_load_balancer" "web" {
  name = "lb-ig"

  listener {
    name = "web-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.ig-2.load_balancer[0].target_group_id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/index.html"
      }
    }
  }
}