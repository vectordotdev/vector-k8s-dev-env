data "kustomization" "flux" {
  path = "${path.module}/../../../cluster/flux-system"
}

resource "kustomization_resource" "flux" {
  for_each = data.kustomization.flux.ids

  manifest = data.kustomization.flux.manifests[each.value]
}
