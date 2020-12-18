variable "git_repo" {
  type        = string
  description = "Git repo to use in the flux-system GitRepository"
}

variable "git_ref_kind" {
  type        = string
  description = "Git ref kind to use in the flux-system GitRepository, can be \"branch\", \"tag\", \"commit\" or \"semver\""
}

variable "git_ref_value" {
  type        = string
  description = "Git ref value to use in the flux-system GitRepository"
}

variable "kustomization_path" {
  type        = string
  description = "Path to the Kustomization directory to use relative to the root of the git repo"
}

variable "git_interval" {
  type        = string
  default     = "1m0s"
  description = "The interval at which to check for repository updates"
}

variable "git_timeout" {
  type        = string
  default     = "20s"
  description = "The timeout for remote Git operations like clonin"
}

variable "kustomization_interval" {
  type        = string
  default     = "10m0s"
  description = "How often to reconcile the Kusomization"
}
