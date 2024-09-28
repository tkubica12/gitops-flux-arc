resource "azurerm_resource_group" "main" {
  name     = "rg-${var.cluster_name}"
  location = var.location
}

resource "azurerm_kubernetes_cluster" "main" {
  name                = "tomks-${var.cluster_name}"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "tomks-${var.cluster_name}"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_kubernetes_cluster_extension" "flux" {
  name           = "flux"
  cluster_id     = azurerm_kubernetes_cluster.main.id
  extension_type = "microsoft.flux"
}

resource "azurerm_kubernetes_flux_configuration" "main" {
  name       = "main"
  cluster_id = azurerm_kubernetes_cluster.main.id
  namespace  = "app1"
  scope      = "namespace"

  git_repository {
    url                      = "https://github.com/tkubica12/gitops-flux-arc"
    reference_type           = "branch"
    reference_value          = "main"
    sync_interval_in_seconds = 300
  }

  kustomizations {
    name                     = "main"
    path                     = "/clusters/${var.cluster_name}/kubernetes"
    sync_interval_in_seconds = 300
    recreating_enabled       = true
  }

  depends_on = [
    azurerm_kubernetes_cluster_extension.flux
  ]
}
