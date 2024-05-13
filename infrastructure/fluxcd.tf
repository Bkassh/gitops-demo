################################################################################
# Installs FluxCD AKS extension with GitRepository and Kustomization resources #
################################################################################

resource "azurerm_kubernetes_cluster_extension" "extension" {
  name              = "${var.aks_name}-fluxcd"
  cluster_id        = azurerm_kubernetes_cluster.k8s.id
  extension_type    = "microsoft.flux"
  release_namespace = "flux-system"

  configuration_settings = {
    "image-automation-controller.enabled" = true,
    "image-reflector-controller.enabled"  = true,
    "notification-controller.enabled"     = true,
  }
}

resource "kubernetes_secret" "secret" {
  metadata {
    name      = "${var.github_repo_name}-repo-secrets"
    namespace = "flux-system"
  }

  data = {
    password = var.github_token
    username = var.github_user
  }

  depends_on = [
    azurerm_kubernetes_cluster_extension.extension
  ]
}

resource "azurerm_kubernetes_flux_configuration" "fluxconfig" {
  name                              = var.github_repo_name
  cluster_id                        = azurerm_kubernetes_cluster.k8s.id
  namespace                         = "flux-system"
  scope                             = "cluster"
  continuous_reconciliation_enabled = true

  git_repository {
    url                      = "https://github.com/${var.github_user}/${var.github_repo_name}"
    reference_type           = "branch"
    reference_value          = var.github_repo_branch
    local_auth_reference     = kubernetes_secret.secret.metadata.0.name
    sync_interval_in_seconds = 60
  }

  kustomizations {
    name                       = "app"
    path                       = "./app"
    garbage_collection_enabled = true
    recreating_enabled         = true
    sync_interval_in_seconds   = 60
  }

  depends_on = [
    kubernetes_secret.secret
  ]
}
