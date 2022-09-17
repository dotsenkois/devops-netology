output "db-hostname" {
    value = [for h in yandex_mdb_mysql_cluster.mysql-netology.host : h.fqdn]
    }

# output "k8c-cluster-ip" {
#     value = [for h in yandex_kubernetes_cluster : h.]
#     }
