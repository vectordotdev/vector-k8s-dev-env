provider "eksctl" {}
provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

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

data "aws_eks_cluster" "primary" {
  name = var.eks_cluster_name

  depends_on = [
    module.eks_cluster,
  ]
}

data "aws_eks_cluster_auth" "primary" {
  name = var.eks_cluster_name

  depends_on = [
    module.eks_cluster,
  ]
}

# We do not initialize it properly, because we only make use it to evaluate
# the kustomization, not to apply it's manifests.
provider "kustomization" {}

provider "kubectl" {
  host                   = data.aws_eks_cluster.primary.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.primary.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.primary.token
  load_config_file       = false
}

module "flux" {
  source = "../flux"

  git_repo           = var.flux_git_repo
  git_ref_kind       = var.flux_git_ref_kind
  git_ref_value      = var.flux_git_ref_value
  kustomization_path = "./cluster/aws"

  providers = {
    kustomization = kustomization
    kubectl       = kubectl
  }

  depends_on = [
    module.eks_cluster,
  ]
}
