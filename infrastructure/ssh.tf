## -----------------------------------------------------------------------------------------------------------
# SSH Key Resources for the Linux profile block required for the AKS Cluster to esnsure best practices
## -----------------------------------------------------------------------------------------------------------
resource "random_pet" "ssh_key_name" {
  prefix    = "ssh"
  separator = ""
}

resource "azapi_resource_action" "ssh_public_key_gen" {
  type        = "Microsoft.Compute/sshPublicKeys@2022-11-01"
  resource_id = azapi_resource.ssh_public_key.id
  action      = "generateKeyPair"
  method      = "POST"
  response_export_values = ["publicKey", "privateKey"]
}

resource "azapi_resource" "ssh_public_key" {
  type      = "Microsoft.Compute/sshPublicKeys@2022-11-01"
  name      = random_pet.ssh_key_name.id
  location  = azurerm_resource_group.rg.location                     # Same as AKS Cluster Resource group location
  parent_id = azurerm_resource_group.rg.id                           # ID of AKS Cluster Resource group
  depends_on = [
    random_pet.ssh_key_name,
  ]
}
