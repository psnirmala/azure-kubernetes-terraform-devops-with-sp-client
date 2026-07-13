
variable client_id {}
variable client_secret {}


resource "azurerm_resource_group" "aks_rg" {
  name     = var.resource_group_name
  location = var.location
}
resource "azurerm_container_registry" "acr" {
  name                = "myregistrydevops2026withsp" # Must be globally unique
  resource_group_name = azurerm_resource_group.aks.name
  location            = azurerm_resource_group.aks.location
  sku                 = "Standard"
}

# Grants AKS permission to pull from your ACR
resource "azurerm_role_assignment" "aks_to_acr" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = var.azurerm_resource_group.aks_rg.location
  resource_group_name = var.azurerm_resource_group.aks_rg.name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name       = "systempool"
    node_count = 2
    vm_size    = "Standard_D2s_v5"
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  tags = {
    Environment = "Production"
  }
}
