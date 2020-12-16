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
  }
}
