## ----------------------------------------------------------------------------
# Installs FluxCD AKS extension with GitRepository and Kustomization resources.
# I am referencing most of the parameter values from my terraform.tfvars file
## ----------------------------------------------------------------------------

resource "azurerm_kubernetes_cluster_extension" "extension" {
  name              = "${var.aks_name}-fluxcd"                              # Name of the FluxCD extension
  cluster_id        = azurerm_kubernetes_cluster.k8s.id                     # AKS Cluster ID
  extension_type    = "microsoft.flux"                                      # type of the extension set to Flux
  release_namespace = "flux-system"                                         # A seperate namespace for FluxCD and application deployed using it.

  configuration_settings = {
    "image-automation-controller.enabled" = true,                           # image-automation-controller is enabled as best practice policy
    "image-reflector-controller.enabled"  = true,                           # image-reflector-controller is enabled as best practice policy
    "notification-controller.enabled"     = true,                           # notification-controller is enabled asbest practice policy
  }
  depends_on = [
    azurerm_resource_group.rg,
    azurerm_kubernetes_cluster.k8s
  ]
}

resource "kubernetes_secret" "secret" {
  metadata {
    name      = "${var.github_repo_name}-repo-secrets"                      # Kubernetes secret name
    namespace = "flux-system"                                               # Same namespace assigned as above
  }

  data = {
    password = var.github_token               # The Personal Access Token of the Github Organization / User where the repository is available for bootstrapping with the AKS Cluster
    username = var.github_user                # The name of the Github Organization / User where the repository is available for bootstrapping with the AKS Cluster
  }

  depends_on = [
    azurerm_kubernetes_cluster_extension.extension
  ]
}

resource "azurerm_kubernetes_flux_configuration" "fluxconfig" {
  name                              = var.github_repo_name                # The Repository name of the Github Organization / User that will be bootstrapped with the AKS Cluster
  cluster_id                        = azurerm_kubernetes_cluster.k8s.id   # AKS Cluster ID
  namespace                         = "flux-system"                       # Same namespace as above
  scope                             = "cluster"                           # Scope provided to the Flux configuration
  continuous_reconciliation_enabled = true

  git_repository {
    url                      = "https://github.com/${var.github_user}/${var.github_repo_name}"  # The URL of the Git Repository
    reference_type           = "branch"                                                         # Reference type is set to Branch
    reference_value          = var.github_repo_branch                                           # The Branch name that would be bootstrapped with the AKS Cluster
    local_auth_reference     = kubernetes_secret.secret.metadata.0.name                         # The Auth reference refering to the Secret generated above
    sync_interval_in_seconds = 60                                                               # The time interval in seconds after which every synchronization should happen
  }

# Kustomization configuation
  kustomizations {
    name                       = "app"                          #Name of Kustomization
    path                       = "./app"                        # Path of the repository resources that should be GitOps enabled
    garbage_collection_enabled = true                           # Garbage collection is enabled
    recreating_enabled         = true                           # Boolean tag to enable / disable Kubernetes resources re-creation on the cluster when patching fails due to an immutable field change  
    sync_interval_in_seconds   = 60                             # The time interval in seconds for GitOps synchronization
  }

  depends_on = [
    kubernetes_secret.secret
  ]
}
