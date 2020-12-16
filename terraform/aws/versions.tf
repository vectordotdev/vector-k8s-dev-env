terraform {
  required_version = ">= 0.14"

  required_providers {
    eksctl = {
      source  = "mumoshu/eksctl"
      version = "0.13.4"
    }
    shell = {
      source  = "scottwinkler/shell"
      version = "1.7.7"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "3.21.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }
    kustomization = {
      source  = "kbst/kustomization"
      version = "0.3.0"
    }
  }
}
