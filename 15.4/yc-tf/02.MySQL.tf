resource "yandex_mdb_mysql_cluster" "mysql-netology" {
  name                = "mysql-netology"
  environment         = "PRESTABLE"
  network_id          =  yandex_vpc_network.db-network.id
  version             = "8.0"
  security_group_ids  = [ yandex_vpc_security_group.db-security.id ]
  deletion_protection = true

  resources {
    resource_preset_id = "s1.medium"
    disk_type_id       = "network-hdd"
    disk_size          = 20
  }

host {
    zone      = var.yc_zone
    subnet_id = yandex_vpc_subnet.private-zone-a.id
  }
host {
    zone      = var.yc_zone
    subnet_id = yandex_vpc_subnet.private-zone-b.id
  }

maintenance_window {
    type =  "WEEKLY"
    day  = "SAT"
    hour = 23
  }
backup_window_start {
    hours   = 23
    minutes = 59
  }
}

resource "yandex_mdb_mysql_database" "netology_db" {
  cluster_id = yandex_mdb_mysql_cluster.mysql-netology.id
  name       = "netology_db"
}

resource "yandex_mdb_mysql_user" "db-user" {
  cluster_id = yandex_mdb_mysql_cluster.mysql-netology.id
  name       = "db-user"
  password   = "password"
  permission {
    database_name = yandex_mdb_mysql_database.netology_db.name
    roles         = ["ALL"]
  }
}

