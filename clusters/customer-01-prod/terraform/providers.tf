terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4"
    }
  }
  backend "azurerm" { # Change this to "local" for local backend
    resource_group_name  = "rg-base"
    storage_account_name = "tomaskubicatf"
    container_name       = "tfstate"
    key                  = "gitops-flux-arc.customer_01_prod.tfstate"
  }
}

provider "azurerm" {
  subscription_id = "673af34d-6b28-41dc-bc7b-f507418045e6"

  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
