variable "resource_group_name" {
  default = "aks-production-rg"
}

variable "location" {
  default = "eastus"
}

variable "cluster_name" {
  default = "aks-production-cluster"
}

variable "dns_prefix" {
  default = "productionaks"
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_container_registry" "acr" {
  name                = "pythondockeracr20261111"  # Must be globally unique
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  admin_enabled       = true
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "python-aks-cluster"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_D2s_v3"
  }

  # Explicitly configure cluster authentication with the Service Principal
  service_principal {
    client_id     = "YOUR_SERVICE_PRINCIPAL_CLIENT_ID"
    client_secret = "YOUR_SERVICE_PRINCIPAL_CLIENT_SECRET"
  }
}

# Grant AKS permissions to pull images from ACR
resource "azurerm_role_assignment" "acr_pull" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}
