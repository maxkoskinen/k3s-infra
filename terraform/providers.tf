terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.38.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.0.2"
    }
  }

  required_version = ">= 1.5.0"
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "k3s-maxhomelab"
}

provider "helm" {
  kubernetes = {
    config_path    = "~/.kube/config"
    config_context = "k3s-maxhomelab"
  }
}
