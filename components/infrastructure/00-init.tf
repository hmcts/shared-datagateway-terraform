terraform {
  required_version = ">= 1.3.2"

  backend "azurerm" {
  }

  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      configuration_aliases = [azurerm.cnp, azurerm.soc]
      version               = ">= 3.75.0"
    }
  }
}

resource "azurerm_windows_virtual_machine_scale_set" "windows_scale_set" {
}
provider "azurerm" {
  features {}
  skip_provider_registration = true
}

provider "azurerm" {
  alias = "hub"
  features {}
  skip_provider_registration = true
  subscription_id            = var.hub_subscription_id
}

provider "azurerm" {
  alias = "soc"
  features {}
  subscription_id = "8ae5b3b6-0b12-4888-b894-4cec33c92292"
}

provider "azurerm" {
  alias = "cnp"
  features {}
  subscription_id = var.cnp_vault_sub
}
