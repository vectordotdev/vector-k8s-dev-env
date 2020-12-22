variable "domain_name" {
  type        = string
  default     = "k8s-dev-env"
  description = "AWS ElasticSearch Domain name"
}

variable "access_policies" {
  type = list(object({
    effect        = string
    actions       = list(string)
    aws_role_arns = list(string)
  }))
  default     = []
  description = "The resource-based access policies to apply"
}
