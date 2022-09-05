output "hostname" {
    value = [for h in yandex_mdb_mysql_cluster.mysql-netology.host : h.fqdn]
    }

output "ip_addr" {
    value = [for h in yandex_mdb_mysql_cluster.mysql-netology.host : h.assign_public_ip]
    }