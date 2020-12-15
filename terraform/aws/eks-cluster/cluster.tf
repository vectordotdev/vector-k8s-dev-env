resource "eksctl_cluster" "primary" {
  eksctl_version = var.eksctl_version
  name           = var.name
  region         = var.region
  version        = "1.18"
  spec           = <<-EOS
    iam:
      withOIDC: true

    managedNodeGroups:
      - name: ${var.node_group_name}
        instanceType: ${var.instance_type}
        desiredCapacity: ${var.nodes_count}
  EOS

  lifecycle {
    prevent_destroy = true
  }
}
