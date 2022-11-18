terraform {
  required_version = ">= 1.3.2"

  backend "azurerm" {
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.88.1"
    }
  }
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


