resource "yandex_vpc_security_group" "db-security" {
  name        = "db-security"
  description = "security group for MySQL cluster"
  network_id  = "${yandex_vpc_network.db-network.id}"

  ingress {
    protocol       = "TCP"
    description    = "incoming connection form ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 3306
  }

  egress {
    protocol       = "ANY"
    description    = "incoming connection to ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port     = 3306
  }
  

}