## ------------------------------------------------------------------------
# To create Log Analytics Workspace to aggregrate logs from AKS nodes and pods
## ------------------------------------------------------------------------
resource "azurerm_log_analytics_workspace" "workspace" {
  name                = lower("log-analytics-workspace-${var.aks_name}")
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = var.log_analytics_workspace_sku
  retention_in_days   = var.log_analytics_retention_days
  tags = {
    Environment = var.aks_environment
  }
  depends_on = [
    azurerm_resource_group.rg
  ]
}

## ------------------------------------------------------------------------
# To create log analytics workspace solution to get container insights
## ------------------------------------------------------------------------
resource "azurerm_log_analytics_solution" "workspace_solution" {
  solution_name         = "ContainerInsights"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  workspace_resource_id = azurerm_log_analytics_workspace.workspace.id
  workspace_name        = azurerm_log_analytics_workspace.workspace.name
  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
  depends_on = [
    azurerm_log_analytics_workspace.workspace,
  ]
}
