
resource "null_resource" "kubeconfig" {
  provisioner "local-exec" {
    command = "yc managed-kubernetes cluster get-credentials ${yandex_kubernetes_cluster.k8s-netology.id} --external --force"
  }

  depends_on = [
    yandex_kubernetes_cluster.k8s-netology,
    yandex_kubernetes_node_group.k8s-netology-node-group
  ]
}


resource "local_file" "connect-to-db" {
  filename = "../mainfests/01.php.yml"
  content  = <<-EOT
---
apiVersion: v1
kind: Secret
metadata:
  name: mysql-secrets
type: Opaque
data:
  root-password: c3VwZXItc2VjcmV0LXBhc3N3b3Jk
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: phpmyadmin-deployment
  labels:
    app: phpmyadmin
spec:
  replicas: 3
  selector:
    matchLabels:
      app: phpmyadmin
  template:
    metadata:
      labels:
        app: phpmyadmin
    spec:
      containers:
        - name: phpmyadmin
          image: phpmyadmin/phpmyadmin:latest
          ports:
            - containerPort: 80
          env:
            - name: PMA_HOST
              value: "${yandex_mdb_mysql_cluster.mysql-netology.host[0].fqdn}"
            - name: PMA_PORT
              value: "3306"
            - name: MYSQL_ROOT_PASSWORD
              value: "password"
---

apiVersion: v1
kind: Service
metadata:
  name: phpmyadmin-service
spec:
  selector:
    app: phpmyadmin
  ports:
    - port: 80
      targetPort: 80
  type: LoadBalancer



EOT

  depends_on = [
    null_resource.kubeconfig,
    yandex_mdb_mysql_cluster.mysql-netology,
    yandex_kubernetes_cluster.k8s-netology
  ]
}

resource "null_resource" "manifests" {
  provisioner "local-exec" {
    command = "kubectl apply -f ../mainfests/01.php.yml "
  }

  depends_on = [
    local_file.connect-to-db
  ]
}
