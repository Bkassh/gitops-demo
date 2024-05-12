## ---------------------------------------------------
# Admin username for Azure K8s Cluster
## ---------------------------------------------------
resource "random_string" "username" {
  length  = 8
  special = false
  upper   = false
}

## ---------------------------------------------------
# Resources
## ---------------------------------------------------
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

## ---------------------------------------------------
# Azure Kubernetes Cluster and components
## ---------------------------------------------------
resource "azurerm_kubernetes_cluster" "k8s" {
  name                          = var.aks_name
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = azurerm_resource_group.rg.location
  dns_prefix                    = var.dns-prefix # The "dns_prefix" must begin or end with a letter or number, contain only letters, numbers, and '-' and be 1 to 54 characters in length
  node_resource_group           = var.node_resource_group

  azure_active_directory_role_based_access_control {
    managed                = true
    azure_rbac_enabled     = true
  }
  network_profile {
    load_balancer_sku    = var.load_balancer_sku
    network_plugin       = var.network_plugin
    network_plugin_mode  = var.network_plugin_mode
    network_policy       = var.network_policy
  }
  default_node_pool {
    name                = var.default_node_pool_name
    node_count          = var.node_count
    min_count           = var.min_count
    max_count           = var.max_count
    vm_size             = var.vm_size
    ultra_ssd_enabled   = var.is_ultra_ssd_enabled
    scale_down_mode     = var.scale_down_mode
    enable_auto_scaling = true
  }
  identity {
    type = var.identity_type
  }
  linux_profile {
    admin_username = random_string.username.result
    ssh_key {
      key_data = azapi_resource_action.ssh_public_key_gen.output.publicKey
    }
  }
  tags = {
    Environment = var.aks_environment
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "default" {
  name                  = var.node_pool_name # The "name" must begin with letter, contain only lowercase letters and / or numbers between 1 to 12 characters in length
  kubernetes_cluster_id = azurerm_kubernetes_cluster.k8s.id
  mode                  = var.node_pool_type # Node Pool Type
  enable_node_public_ip = false
  enable_auto_scaling   = true
  node_count            = var.node_count
  min_count             = var.min_count
  max_count             = var.max_count
  max_pods              = var.max_pods
  vm_size               = var.vm_size
  os_type               = var.os_type
}
