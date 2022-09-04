terraform {
  backend "s3" {
  endpoint   = "storage.yandexcloud.net"
  bucket     = "clokub-11-bucket"
  region     = "ru-central1"
  key        = "tf/clokub-11.tfstate"
  access_key = "YCAJER-C_lupcOCyG9DUlkSrM"
  secret_key = "YCOuf77BvsYLMAGOiEzuond1cXuTA41MpGuv-0w5"
  skip_region_validation      = true
  skip_credentials_validation = true
}
}

