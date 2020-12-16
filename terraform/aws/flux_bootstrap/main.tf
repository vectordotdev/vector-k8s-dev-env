locals {
  kustomization_path = "${path.module}/../../../cluster/flux-system"
}

resource "shell_script" "flux_bootstrap" {
  lifecycle_commands {
    create = "${path.module}/scripts/apply.sh \"${local.kustomization_path}\""
    read   = "${path.module}/scripts/read.sh \"${local.kustomization_path}\""
    update = "${path.module}/scripts/apply.sh \"${local.kustomization_path}\""
    delete = "${path.module}/scripts/delete.sh \"${local.kustomization_path}\""
  }
}
