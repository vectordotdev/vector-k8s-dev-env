locals {
  kustomization_path = "${path.module}/../../../cluster/flux-system"
}

data "kustomization_build" "flex_system" {
  path = local.kustomization_path
}

# resource "kustomization_resource" "flex_system" {
#   for_each = data.kustomization_build.flex_system.ids
#   manifest = data.kustomization_build.flex_system.manifests[each.value]
# }

resource "kubectl_manifest" "flex_system" {
  for_each  = data.kustomization_build.flex_system.ids
  yaml_body = data.kustomization_build.flex_system.manifests[each.value]
}
