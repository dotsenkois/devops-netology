resource "yandex_kms_symmetric_key" "key-a" {
  name              = "netology-key"
  description       = "Ключ для шифрования k8s cluster"
  default_algorithm = "AES_128"
  rotation_period   = "8760h"
  lifecycle {
    prevent_destroy = false
  }
  }