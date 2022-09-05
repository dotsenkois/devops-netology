resource "yandex_kubernetes_cluster" "k8s-netology" {
 network_id = yandex_vpc_network.k8s-network.id

  master {
    version   = "1.22"
    public_ip = true

    regional {
      region = "ru-central1-a"

      location {
        zone      = yandex_vpc_subnet.k8s-private-zone-a.zone
        subnet_id = yandex_vpc_subnet.k8s-private-zone-a.id
      }

      location {
        zone      = yandex_vpc_subnet.k8s-private-zone-b.zone
        subnet_id = yandex_vpc_subnet.k8s-private-zone-b.id
      }

      location {
        zone      = yandex_vpc_subnet.k8s-private-zone-c.zone
        subnet_id = yandex_vpc_subnet.k8s-private-zone-c.id
      }
    }
 }
 service_account_id      = yandex_iam_service_account.k8s-sa.id
 node_service_account_id = yandex_iam_service_account.k8s-sa.id
   depends_on = [
     yandex_resourcemanager_folder_iam_binding.editor,
     yandex_resourcemanager_folder_iam_binding.images-puller
   ]

kms_provider {
    key_id = yandex_kms_symmetric_key.key-a.id
  }

  release_channel = "STABLE"

}

