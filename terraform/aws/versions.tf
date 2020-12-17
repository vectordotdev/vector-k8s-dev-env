terraform {
  required_version = ">= 0.14"

  required_providers {
    eksctl = {
      source  = "mumoshu/eksctl"
      version = "0.13.4"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "3.21.0"
    }
    kustomization = {
      source  = "kbst/kustomization"
      version = "0.3.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.9.4"
    }
  }
}
