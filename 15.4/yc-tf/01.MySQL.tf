resource "yandex_mdb_mysql_cluster" "mysql-netology" {
  name                = "mysql-netology"
  environment         = "PRESTABLE"
  network_id          =  yandex_vpc_network.db-network.id
  version             = "8.0"
  security_group_ids  = [ yandex_vpc_security_group.db-security.id ]
  deletion_protection = false

  resources {
    resource_preset_id = "s1.medium"
    disk_type_id       = "network-ssd"
    disk_size          = 20

  }

host {
    zone      = yandex_vpc_subnet.db-zone-a.zone
    subnet_id = yandex_vpc_subnet.db-zone-a.id
    name = "node-a-1"
  }
host {
    zone      = yandex_vpc_subnet.db-zone-b.zone
    subnet_id = yandex_vpc_subnet.db-zone-b.id
    name = "node-b-1"
    replication_source_name = "node-a-1"
  }


maintenance_window {
    type = "ANYTIME"
  }

backup_window_start {
    hours   = 23
    minutes = 59
  }

    depends_on = [
     yandex_vpc_subnet.db-zone-a,
     yandex_vpc_subnet.db-zone-b
   ]
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

