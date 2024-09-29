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

resource "azurerm_kubernetes_flux_configuration" "apps" {
  name       = "apps"
  cluster_id = azurerm_kubernetes_cluster.main.id
  namespace  = "apps"
  scope      = "namespace"

  git_repository {
    url                      = "https://github.com/tkubica12/gitops-flux-arc"
    reference_type           = "branch"
    reference_value          = "main"
    sync_interval_in_seconds = 60
  }

  kustomizations {
    name                     = "apps"
    path                     = "/clusters/${var.cluster_name}/apps"
    sync_interval_in_seconds = 60
    recreating_enabled       = true
  }

  depends_on = [
    azurerm_kubernetes_cluster_extension.flux
  ]
}

resource "azurerm_kubernetes_flux_configuration" "infra" {
  name       = "infra"
  cluster_id = azurerm_kubernetes_cluster.main.id
  namespace  = "infra"
  scope      = "namespace"

  git_repository {
    url                      = "https://github.com/tkubica12/gitops-flux-arc"
    reference_type           = "branch"
    reference_value          = "main"
    sync_interval_in_seconds = 60
  }

  kustomizations {
    name                     = "infra"
    path                     = "/clusters/${var.cluster_name}/infra"
    sync_interval_in_seconds = 60
    recreating_enabled       = true
  }

  depends_on = [
    azurerm_kubernetes_cluster_extension.flux
  ]
}
