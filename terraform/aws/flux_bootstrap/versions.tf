terraform {
  required_providers {
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
