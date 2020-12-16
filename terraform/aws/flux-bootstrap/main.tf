locals {
  kustomization_path = "${path.module}/../../../cluster/flux-system"
}

resource "shell_script" "flux_bootstrap" {
  lifecycle_commands {
    create = "kubectl apply -k ${local.kustomization_path}"
    read   = "kubectl get -k ${local.kustomization_path} -o jsonpath='{\"{\"}\"state\":[{range .items[*]}\"{.apiVersion}|{.kind}|{.metadata.name}\"{\",\"}{end}\"\"]{\"}\"}'"
    update = "kubectl apply -k ${local.kustomization_path}"
    delete = "kubectl delete -k ${local.kustomization_path}"
  }
}
