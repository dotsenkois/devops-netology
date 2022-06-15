# https://habr.com/ru/company/flant/blog/470503/

useradd -m logreader && cd /home/logreader
openssl genrsa -out logreader.key 2048

openssl req -new -key logreader.key \
-out logreader.csr \
-subj "/CN=logreader"

openssl x509 -req -in logreader.csr \
-CA /etc/kubernetes/pki/ca.crt \
-CAkey /etc/kubernetes/pki/ca.key \
-CAcreateserial \
-out logreader.crt -days 500

mkdir .certs && mv logreader.crt logreader.key .certs

kubectl config set-credentials logreader \
--client-certificate=/home/logreader/.certs/logreader.crt \
--client-key=/home/logreader/.certs/logreader.key

kubectl config set-context logreader-context \
--cluster=kubernetes --user=logreader
##
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJeU1EWXhOVEUwTWpVMU5Wb1hEVE15TURZeE1qRTBNalUxTlZvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTDVmCkhWQXdtcy9WY0ZhcVdrNVdleC84WXdyZ1p4cS83M2VDaXdpVllCYVRYU3VVL1VKNjBOQitYUEZscmg1TnBMankKRWxGMDRlVVJBVEFGOWltYXNDcXVmRjR3Ly9PRGNULzg1WEx1OTloTExRbzJiL09FdTFrMGdCck9WSmF2dDQ0OAovbllFMEEwSWVvdGl6VWdIOVZZbncxaTRBM3VYVlhHK0k5ZFFtOGN5Wjc4YmVEcFNYSmIvbU10NTZBRjY1MlE3CktBbVJYZXl1emNKWXg0c1A0SHdoT281b1VxeE4vZGVZdUltNnhUNHJNdTI1UVlrUkRKMXVvZDRkTm9aSHRucmEKbkdyR2pYTVh2aEFNQ3FvbEhvY2RzLzk5Tk9BUys4NFRNWXE1a2dlUytOYzMxMmYwTDVCcXY3bkRxMjRkYXpjTQpVR0d5L09XRXEzVHB4MXgzbWtNQ0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZDblNIRFQyTlVaQUJCS0d3a2NGMzRpaE54c1BNQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBQVlGYVlvdXJEenJIaXIyb0dHSAp4RksrMXdEODJnOExQTVRubWRRZTZWczFJdVR1UXRTV0F6UHVMbW8ySHFEbS9xck5VUXpCdnZBdmx6dDBnc0lDClE3QlNGT3o3WmxnekN0RmhyTUZ6RjZuMm1QUXNzTGhxZ3RlWmc1YzNvVGxUcXZkbTNUcHZVQVVrRGFGeGdpcHEKVDJSc0diYmVXcFR4c3M3cTRHQS9IejRFZmR5cWwycVFnd3JQUEtOVUJIenZkR20xd0o0cVBBQXE1SWlUejdMegpGTER2eHVGMW9VS1orbHZOemo5UzR6MjZubmVqNXBUeXN0aFE5UmJFd1VndFhXTDhoc2FqaWJvcXhmMytGSDl4Cld3aE8vTUtCNlJLZ1JWZ2tycmZvUWxTL3hoYWc1czBYNStIeHFZMTY3bEpWenNESXVtZVJtOTlHK0xUNjdDRUwKc0RrPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==
    server: https://10.130.0.20:6443
    name: kubernetes
contexts:
- context:
 cluster: kubernetes
 user: logreader
name: logreader-context
current-context: logreader-context
kind: Config
preferences: {}
users:
- name: logreader
  user:
    client-certificate: /home/logreader/.certs/logreader.cert
    client-key: /home/logreader/.certs/logreader.key
##

mkdir .kube && nano .kube/config
chown -R logreader: /home/logreader/

kubectl create namespace app-namespace

##
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: Role
metadata:
  name: list-deployments
  namespace: app-namespace
rules:
  - apiGroups: [ apps ]
    resources: [ deployments ]
    verbs: [ get, list ]
---------------------------------
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRole
metadata:
  name: list-deployments
rules:
  - apiGroups: [ apps ]
    resources: [ deployments ]
    verbs: [ get, list ]
##