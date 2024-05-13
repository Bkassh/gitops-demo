## ---------------------------------------------------
# Variables for Resource Group Creation
## ---------------------------------------------------
variable "resource_group_name" {
  type        = string
  description = "String containing Resource Group name"
}
variable "resource_group_location" {
  type        = string
  description = "String containing Resource Group location"
}

## ---------------------------------------------------
# Variables for Azure K8s Cluster Creation
## ---------------------------------------------------
variable "aks_name" {
  type        = string
  description = "String containing AKS Cluster name"
}
variable "dns-prefix" {
  type        = string
  description = "String containing AKS DNS name"
}
variable "node_resource_group" {
  type        = string
  description = "String containing Node Resource Group name"
}
variable "node_pool_name" {
  type        = string
  description = "String containing Node Pool name"
}
variable "default_node_pool_name" {
  type        = string
  description = "String containing default Node Pool name"
}
variable "node_pool_type" {
  type        = string
  description = "String containing Node Pool type"
}
variable "node_count" {
  type        = number
  description = "Number containing Node count"
}
variable "min_count" {
  type        = number
  description = "Number containing minimum Node count"
}
variable "max_count" {
  type        = number
  description = "Number containing maximum Node count"
}
variable "max_pods" {
  type        = number
  description = "Number containing maximum number of allowed Pods on the AKS cluster"
}
variable "vm_size" {
  type        = string
  description = "String containing VM size"
}
variable "os_type" {
  type        = string
  description = "String containing OS type"
}
variable "identity_type" {
  type        = string
  description = "String containing Identity type"
}
variable "aks_environment" {
  type        = string
  description = "String containing Environment of AKS Cluster"
}
variable "scale_down_mode" {
  type        = string
  description = "String containing mode of how Nodes are Scaled Down"
}
variable "is_ultra_ssd_enabled" {
  type        = bool
  description = "Boolean value whether Ultra SSD is Enabled"
}
variable "load_balancer_sku" {
  type        = string
  description = "String containing Load Balancer sku"
}
variable "network_plugin" {
  type        = string
  description = "String containing Network Plugin type"
}
variable "network_plugin_mode" {
  type        = string
  description = "String containing Network Plugin mode"
}
variable "network_policy" {
  type        = string
  description = "String containing Network policy"
}
variable "github_user" {
  type        = string
  description = "String containing Github Repository username"
}
variable "github_token" {
  type        = string
  description = "String containing Github Repository token(classic)"
}
variable "github_repo_name" {
  type        = string
  description = "String containing Github Repository name"
}
variable "github_repo_branch" {
  type        = string
  description = "String containing Github Repository branch name"
}

## ---------------------------------------------------
# Variables for Azure Log Analytics
## ---------------------------------------------------
variable "log_analytics_workspace_sku" {
  description = "(Optional) Specifies the sku of the log analytics workspace"
  type        = string
  default     = "PerGB2018"
  validation {
    condition     = contains(["Free", "Standalone", "PerNode", "PerGB2018"], var.log_analytics_workspace_sku)
    error_message = "The log analytics sku is incorrect."
  }
}
variable "log_analytics_retention_days" {
  description = " (Optional) Specifies the workspace data retention in days. Possible values are either 7 (Free Tier only) or range between 30 and 730."
  type        = number
  default     = 30
}
