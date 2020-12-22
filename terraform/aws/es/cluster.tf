data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

locals {
  tags = {
    Domain    = var.domain_name
    ManagedBy = "vector-k8s-dev-env"
  }
}

resource "aws_elasticsearch_domain" "primary" {
  domain_name           = var.domain_name
  elasticsearch_version = "7.9"

  cluster_config {
    instance_type            = "t2.medium.elasticsearch"
    instance_count           = 1
    dedicated_master_enabled = false
  }

  ebs_options {
    ebs_enabled = true
    volume_type = "gp2"
    volume_size = "20"
  }

  snapshot_options {
    automated_snapshot_start_hour = 7
  }

  access_policies = data.aws_iam_policy_document.access_policies.json

  tags = local.tags
}

data "aws_iam_policy_document" "access_policies" {
  dynamic "statement" {
    for_each = var.access_policies
    content {
      sid     = statement.key
      effect  = statement.value.effect
      actions = statement.value.actions

      principals {
        type        = "AWS"
        identifiers = statement.value.aws_role_arns
      }

      resources = [
        "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.domain_name}/*"
      ]
    }
  }
}
