apiVersion: v1
kind: Config
clusters:
- cluster:
certificate-authority-data: ${CLUSTER_CA}
server: ${CLUSTER_ENDPOINT}
name: ${CLUSTER_NAME}
users:
- name: logreader
user:
client-certificate-data: ${CLIENT_CERTIFICATE_DATA}
contexts:
- context:
cluster: ${CLUSTER_NAME}
user: logreader
name: logreader
current-context: logreader