variable "name" {
  type        = string
  default     = "k8s-dev-env"
  description = "AWS EKS Cluster name"
}

variable "region" {
  type        = string
  default     = "us-east-2"
  description = "AWS region"
}

variable "node_group_name" {
  type        = string
  default     = "ng-1"
  description = "AWS EKS Node Group name"
}

variable "instance_type" {
  type        = string
  default     = "t3.medium"
  description = "AWS EC2 instance type for cluster nodes"
}

variable "nodes_count" {
  type        = number
  default     = 3
  description = "The desired number of instances in the AWS EKS cluster node group"
}
