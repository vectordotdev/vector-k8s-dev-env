provider "eksctl" {}
provider "shell" {}

module "eks-cluster" {
  source = "./eks-cluster"
  vars   = vars.eks_cluster
}

module "flux-bootstrap" {
  source = "./flux-bootstrap"

  depends_on = [
    module.eks_cluster,
  ]
}
