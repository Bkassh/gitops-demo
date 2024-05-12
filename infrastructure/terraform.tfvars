########## Resource Group ##########
resource_group_name = "rg-compredict"
resource_group_location = "eastus2"
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
admin_group_object_ids = ["ac46a79c-505c-4b60-8ee4-b69a370ec4ac"]
#admin_group_object_ids = ["20f3de49-db1c-4c60-af56-cc9494ed502d"]
########## Target Git repository properties ##########
github_user = "Bkassh"
github_token = "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"
github_repo_name = "infrastructure-compredict"
github_repo_branch = "main"
