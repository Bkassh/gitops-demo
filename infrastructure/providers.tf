terraform {
  # ---------------------------------------------------
  # Setup  for providers for Terraform execution
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
  # HCP Terraform is available as a hosted service at https://app.terraform.io. 
  # I am using it to share variables, run Terraform in a stable remote environment and securely store remote state
  # mainly to utilize Hashicorp Sentinel policies while running Github Action workflows from Github repository. To run Terraform locally
  # the backend block should be Block commented or adjusted accordingly.
  backend "remote" {                               
		hostname = "app.terraform.io"                                   # My hostname
		organization = "Bikash-Terraform-Demo"                          # My organization name in host

		workspaces {
			name = "compredict-aks-demo"                                  # The name of the workspace that I created in the host
		}
	}
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false               # Set to ensure complete destruction of Resources on applying command "terraform destroy --auto-approve"
    }
  }
  environment = "public"
}

provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.k8s.kube_config.0.host                                    # hostname of AKS Cluster as obtained from kube config
  username               = azurerm_kubernetes_cluster.k8s.kube_config.0.username                                # username of AKS Cluster as obtained from kube config
  password               = azurerm_kubernetes_cluster.k8s.kube_config.0.password                                # password of AKS Cluster as obtained from kube config
  client_certificate     = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate)        # client certificate of AKS Cluster
  client_key             = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_key)                # client key of AKS Cluster
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.cluster_ca_certificate)    # Cluster CA Certificate value
}

