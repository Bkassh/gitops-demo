########## Resource Group ##########
resource_group_name = "rg-compredict"
resource_group_location = "westeurope"
########## Azure Kubernetes Cluster ##########
aks_name = "aks-compredict"
dns-prefix = "dns-compredict"
node_resource_group = "rg-compredict-node"
node_pool_name = "nod4appdploy"
default_node_pool_name = "system"
node_pool_type = "User"
node_count = 1
min_count = 1
max_count = 5
max_pods = 10
vm_size = "Standard_B2ms"
os_type = "Linux"
identity_type = "SystemAssigned"
aks_environment = "Development"
scale_down_mode = "Delete"
is_ultra_ssd_enabled = false
load_balancer_sku = "standard"
network_plugin = "azure"
network_plugin_mode = "overlay"
network_policy = "calico"
########## Target Git repository properties ##########
github_user = "Bkassh"
github_repo_name = "compredict-demoapp"
github_repo_branch = "main"
########## Azure Log Analytics properties ##########
log_analytics_workspace_sku = "PerGB2018"
log_analytics_retention_days = 30