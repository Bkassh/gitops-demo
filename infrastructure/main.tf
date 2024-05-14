## ---------------------------------------------------
# Admin username for Azure K8s Cluster
## ---------------------------------------------------
resource "random_string" "username" {
  length  = 8      # Maximum length of the AKS Admin username
  special = false  # As per the naming criteria, No special characters can be included in the name
  upper   = false  # As per the naming criteria, the name should not have any uppercase letters
  numeric = false  # As per the naming criteria, the name should not have numbers or start with a number
}

## -----------------------------------------------------------------------------------------------------------
# Resources for the Azure Kubernetes Cluster. I am referencing the parameter values from terraform.tfvars file
## -----------------------------------------------------------------------------------------------------------
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name       # The Resource Group name
  location = var.resource_group_location   # The location of the Resource Group
}

## ----------------------------------------------------------------------------------------------------------------
# Azure Kubernetes Cluster and components. I am referencing most of the parameter values from terraform.tfvars file
## ----------------------------------------------------------------------------------------------------------------
resource "azurerm_kubernetes_cluster" "k8s" {
  name                          = var.aks_name                            # The name of the AKS cluster that will be created
  resource_group_name           = azurerm_resource_group.rg.name          # The resource group name of the AKS Cluster
  location                      = azurerm_resource_group.rg.location      # The location of the AKS Cluster 
  dns_prefix                    = var.dns-prefix                          # The "dns_prefix" must begin or end with a letter or number, contain only letters, numbers, and '-' and be 1 to 54 characters in length
  node_resource_group           = var.node_resource_group                 # The name of the AKS Cluster node Resource Group
  azure_policy_enabled          = true                                    # Standed security policy provided by Azure after the deprecation of Pod Security policy in October 15th, 2020

  network_profile {
    load_balancer_sku    = var.load_balancer_sku    # The type of Loadbalancer SKU
    network_plugin       = var.network_plugin       # The type of Network plugin
    network_plugin_mode  = var.network_plugin_mode  # The mode of Network plugin
    network_policy       = var.network_policy       # The Network policy applied in the AKS.
  }
  default_node_pool {
    name                = var.default_node_pool_name    # Name of the default node pool in the AKS Cluster
    node_count          = var.node_count                # The number of Nodes available by default in the AKS Cluster
    enable_auto_scaling = true                          # Autoscaling should be anabled to True as it automatically adjusts the number of nodes in your cluster when pods fail to launch due to lack of resources or when nodes in the cluster are underutilized and their pods can be rescheduled onto other nodes in the cluster
    min_count           = var.min_count                 # Minimum node count as Auto scaling is set to True
    max_count           = var.max_count                 # Maximum node count as Auto Scaling is set to True
    vm_size             = var.vm_size                   # VM used. Used Standard_B2ms as it is ideal for proof of concepts, small databases and development build environments
    ultra_ssd_enabled   = var.is_ultra_ssd_enabled      # Boolean flag to enable / disable the capacity of Data Disks of the UltraSSD_LRS storage account type be supported on the VM. Set to false in the Project
    scale_down_mode     = var.scale_down_mode           # As Autoscaling is enabled, the Scaled downed nodes can be set to be Deallocated or Deleted with this tag. I have set to "Delete"
  }
  identity {
    type = var.identity_type                                                  # Identity type
  }
  linux_profile {
    admin_username = random_string.username.result                            # Name of the AKS admin as generated above
    ssh_key {
      key_data = azapi_resource_action.ssh_public_key_gen.output.publicKey    # Key data of the AKS Cluster
    }
  }
  tags = {
    Environment = var.aks_environment                                         # Tye of Environment tag of the AKS Cluster
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "default" {
  name                  = var.node_pool_name                    # The "name" must begin with letter, contain only lowercase letters and / or numbers between 1 to 12 characters in length
  kubernetes_cluster_id = azurerm_kubernetes_cluster.k8s.id     # AKS Cluster ID after creation
  mode                  = var.node_pool_type                    # Node Pool Type
  enable_node_public_ip = false                                 # Bolean value whether each node should have a Public IP Address, I have set to False
  enable_auto_scaling   = true                                  # As an AKS cluster best practice reccomendation, I have enabled Auto Scaling of the cluster node pool
  node_count            = var.node_count                        # Set to same value as the Default node pool
  min_count             = var.min_count                         # Set to same value as the Default node pool
  max_count             = var.max_count                         # Set to same value as the Default node pool
  max_pods              = var.max_pods                          # I haveset the maximum number of pods that can be deployed to 10
  vm_size               = var.vm_size                           # Set to same value as the Default node pool
  os_type               = var.os_type                           # Set to same value as the Default node pool
  node_labels = {
    "app"           = "compredictdemo"                     # Label added to configure deployed pod affinity
    "environment"   = var.aks_environment                       # Label added to configure deployed pod affinity
  } 
}
