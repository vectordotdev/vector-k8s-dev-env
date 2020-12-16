apiVersion: v1
kind: Config
preferences:
  colors: true
current-context: k8s-dev-env
contexts:
- context:
    cluster: k8s-dev-env
    namespace: default
    user: user
  name: k8s-dev-env
clusters:
- cluster:
    server: ${endpoint}
    certificate-authority-data: ${cluster_ca_certificate}
  name: k8s-dev-env
users:
- name: user
  user:
    token: ${token}
