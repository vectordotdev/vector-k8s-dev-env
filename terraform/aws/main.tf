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

module "vector_service_account_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "3.6.0"

  create_role                   = true
  role_name                     = "${var.eks_cluster_name}-sa-vector"
  provider_url                  = replace(data.aws_eks_cluster.primary.identity.0.oidc.0.issuer, "https://", "")
  role_policy_arns              = []
  oidc_fully_qualified_subjects = ["system:serviceaccount:vector:*"]

  providers = {
    aws = aws
  }
}

# Inject this `ConfigMap` into the cluster - the flux-managed config expect
# it to be present and will consume the data we provide here.
resource "kubectl_manifest" "vector_injected_configmap" {
  yaml_body = <<-YAML
    apiVersion: v1
    kind: ConfigMap
    metadata:
      namespace: vector
      name: terraform-injected-values
    data:
      helm-chart-values.yaml: |
        vector-aggregator:
          serviceAccount:
            annotations:
              eks.amazonaws.com/role-arn: arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${module.vector_service_account_role.this_iam_role_name}
  YAML

  depends_on = [
    module.flux
  ]
}
