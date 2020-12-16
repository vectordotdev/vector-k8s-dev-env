provider "eksctl" {}
provider "shell" {}
provider "aws" {
  region = var.region
}

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

data "template_file" "kubeconfig" {
  template = file("${path.module}/kubeconfig.yaml.tpl")
  vars = {
    endpoint               = data.aws_eks_cluster.primary.endpoint
    cluster_ca_certificate = data.aws_eks_cluster.primary.certificate_authority[0].data
    token                  = data.aws_eks_cluster_auth.primary.token
  }
}

provider "kustomization" {
  kubeconfig_raw = data.template_file.kubeconfig.rendered
  context        = "k8s-dev-env"
}

module "flux_bootstrap" {
  source = "./flux_bootstrap"

  providers = {
    kustomization = kustomization
  }

  depends_on = [
    module.eks_cluster,
  ]
}
