variable "region" {
  type        = string
  default     = "us-east-2"
  description = "AWS region"
}

variable "eks_cluster_name" {
  type        = string
  default     = "k8s-dev-env"
  description = "AWS EKS Cluster name"
}

variable "eks_cluster_node_group_name" {
  type        = string
  default     = "ng-1"
  description = "AWS EKS Node Group name"
}

variable "eks_cluster_instance_type" {
  type        = string
  default     = "t3.medium"
  description = "AWS EC2 instance type for AWS EKS cluster nodes"
}

variable "eks_cluster_nodes_count" {
  type        = number
  default     = 3
  description = "The desired number of instances in the AWS EKS cluster node group"
}

variable "eks_cluster_eksctl_version" {
  type        = string
  default     = ""
  description = "The eksctl version to use, if empty the system version is used"
}

variable "flux_git_repo" {
  type        = string
  description = "Git repo to use in the flux-system GitRepository"
}

variable "flux_git_ref_kind" {
  type        = string
  description = "Git ref kind to use in the flux-system GitRepository, can be \"branch\", \"tag\", \"commit\" or \"semver\""
}

variable "flux_git_ref_value" {
  type        = string
  description = "Git ref value to use in the flux-system GitRepository"
}
