provider "eksctl" {}
provider "shell" {}

module "eks_cluster" {
  source = "./eks_cluster"

  providers = {
    eksctl = eksctl
  }

  name            = var.eks_cluster_name
  region          = var.region
  node_group_name = var.eks_cluster_node_group_name
  instance_type   = var.eks_cluster_instance_type
  nodes_count     = var.eks_cluster_nodes_count
  eksctl_version  = var.eks_cluster_eksctl_version
}

module "flux_bootstrap" {
  source = "./flux_bootstrap"

  providers = {
    shell = shell
  }

  depends_on = [
    module.eks_cluster,
  ]
}
