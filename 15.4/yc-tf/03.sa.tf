
resource "yandex_iam_service_account" "k8s-sa" {
 name        = "k8s-sa"
 description = "for managing k8s cluster"
}

resource "yandex_resourcemanager_folder_iam_binding" "editor" {
 # Сервисному аккаунту назначается роль "editor".
 folder_id = var.yc_folder_id
 role      = "editor"
 members   = [
   "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
 ]
}

resource "yandex_resourcemanager_folder_iam_binding" "images-puller" {
 # Сервисному аккаунту назначается роль "container-registry.images.puller".
 folder_id = var.yc_folder_id
 role      = "container-registry.images.puller"
 members   = [
   "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
 ]
}


resource "yandex_iam_service_account_static_access_key" "k8s-sa-static-key" {
  service_account_id = yandex_iam_service_account.k8s-sa.id
  description        = "for as k8s admin"
}
