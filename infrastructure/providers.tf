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
