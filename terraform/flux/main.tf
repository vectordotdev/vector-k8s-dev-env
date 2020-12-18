locals {
  flux_resources_path = "${path.module}/../../cluster/flux-system"
}

data "kustomization_build" "flux_system" {
  path = local.flux_resources_path
}

resource "kubectl_manifest" "flux_system" {
  for_each  = data.kustomization_build.flux_system.ids
  yaml_body = data.kustomization_build.flux_system.manifests[each.value]
}

data "kubectl_path_documents" "flux_sync" {
  pattern = "${path.module}/manifests/gotk-sync.yaml"

  vars = {
    git_repo               = var.git_repo
    git_ref_kind           = var.git_ref_kind
    git_ref_value          = var.git_ref_value
    kustomization_path     = var.kustomization_path
    git_interval           = var.git_interval
    git_timeout            = var.git_timeout
    kustomization_interval = var.kustomization_interval
  }
}

resource "kubectl_manifest" "flux_sync" {
  count     = length(data.kubectl_path_documents.flux_sync.documents)
  yaml_body = element(data.kubectl_path_documents.flux_sync.documents, count.index)

  depends_on = [
    kubectl_manifest.flux_system
  ]
}
