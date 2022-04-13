resource "null_resource" "wait" {
  provisioner "local-exec" {
    command = "sleep 30"
  }

  depends_on = [
    local_file.inventory
  ]
}

resource "null_resource" "jenkins" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../infrastructure/inventory/cicd/hosts.yml ../infrastructure/site.yml"
  }

  depends_on = [
    null_resource.wait
  ]
}

resource "null_resource" "url" {
  provisioner "local-exec" {
    command = "echo http://${yandex_compute_instance.jenkins-master.network_interface.0.nat_ip_address}:8080"
  }

  depends_on = [
    null_resource.jenkins
  ]
}
