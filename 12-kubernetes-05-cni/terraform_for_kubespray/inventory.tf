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

k8s_cluster:
  children:
    kube_control_plane:
      hosts:
%{ for node in yandex_compute_instance.control-plane ~} 
        ${node.hostname}:
%{endfor~}
    kube_node:
      hosts:
%{ for node in yandex_compute_instance.worker ~} 
        ${node.hostname}:
%{endfor~}
    etcd:
      hosts:
%{ for node in yandex_compute_instance.control-plane ~} 
        ${node.hostname}:
%{endfor~}
    calico_rr:
      hosts:

  vars:
    ansible_connection_type: paramiko
    ansible_user: dotsenkois
EOT

  depends_on = [
    yandex_compute_instance.control-plane,
    yandex_compute_instance.worker
  ]
}
