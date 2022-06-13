resource "local_file" "inventory" {
  filename = var.HostsPath
  content  = <<-EOT
---
all:
  hosts:
%{ for node in yandex_compute_instance.control-plane ~} 
    ${node.hostname}:
      ansible_host: ${node.network_interface.0.nat_ip_address}
%{endfor~}
%{ for node in yandex_compute_instance.worker ~} 
    ${node.hostname}:
      ansible_host: ${node.network_interface.0.nat_ip_address}
%{endfor~}

  children:
    control-plane:
      hosts:
%{ for node in yandex_compute_instance.control-plane ~} 
        ${node.hostname}:
%{endfor~}
    workers:
      hosts:
%{ for node in yandex_compute_instance.worker ~} 
        ${node.hostname}:
%{endfor~}

  vars:
    ansible_connection_type: paramiko
    ansible_user: dotsenkois
EOT

  depends_on = [
    yandex_compute_instance.control-plane,
    yandex_compute_instance.worker
  ]
}
