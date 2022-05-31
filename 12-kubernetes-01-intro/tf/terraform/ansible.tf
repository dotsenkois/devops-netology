resource "null_resource" "wait" {
  provisioner "local-exec" {
    command = "sleep 50"
  }

  depends_on = [
    local_file.inventory
  ]
}

resource "null_resource" "roles" {
  provisioner "local-exec" {
    command = "ansible-galaxy role install -r ../playbook/requirements.yml -f"
  }

  depends_on = [
    null_resource.wait
  ]
}


resource "null_resource" "minikube" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../playbook/inventory/prod/hosts.yml ../playbook/site.yml"
  }

  depends_on = [
    null_resource.roles
  ]
}
