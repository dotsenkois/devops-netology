## Задание 1. Создание статичного сайта с помощью бакета 

resource "yandex_iam_service_account" "sa-bucket-db-bkp" {
  name      = "sa-bucket-db-bkp"
}

// Назначение роли сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "sa-bucket-db-bkp-editor" {
  folder_id = var.yc_folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa-bucket-db-bkp.id}"
}

// Создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa-bucket-db-bkp.id
  description        = "static access key for bucket-sa object storage"
}


// Создание бакета с использованием ключа
resource "yandex_storage_bucket" "bucket-db-bkp" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = "bucket-db-bkp"
#   acl    = "public-read"
}