terraform {
  # ---------------------------------------------------
  # Setup providers
  # ---------------------------------------------------
  required_version = ">= 1.8.2"
  required_providers {
    azurerm = {
      source = "registry.terraform.io/hashicorp/azurerm"
      version = "~> 3.102.0"
    }
    kubernetes = {
      source = "registry.terraform.io/hashicorp/kubernetes"
      version = "~> 2.29.0"
    }
    random = {
      source = "registry.terraform.io/hashicorp/random"
      version = "~> 3.6.1"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 1.13.1"
    }
    time = {
      source  = "registry.terraform.io/hashicorp/time"
      version = "~>0.9.1"
    }
  }
  backend "remote" {
		hostname = "app.terraform.io"
		organization = "Bikash-Terraform-Demo"

		workspaces {
			name = "compredict-aks-demo"
		}
	}
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  environment = "public"
}

provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.k8s.kube_config.0.host
  username               = azurerm_kubernetes_cluster.k8s.kube_config.0.username
  password               = azurerm_kubernetes_cluster.k8s.kube_config.0.password
  client_certificate     = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.cluster_ca_certificate)
}

