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


#provider "azurerm" {
#  alias = "additional_hub"
#  features {}
#  skip_provider_registration = true
#  subscription_id            = var.additional_hub_subscription_id
#}
#
##provider "azurerm" {
##  alias = "data"
##  features {}
##  subscription_id = var.data_subscription
##}
#
#provider "azurerm" {
#  alias = "dns_zone"
#  features {}
#  subscription_id = var.dns_zone_subscription_id
#}
#
#provider "azurerm" {
#  alias = "hub"
#  features {}
#  subscription_id = var.hub_subscription_id
#}
#
#provider "azurerm" {
#  alias = "mgmt"
#  features {}
#  subscription_id = var.mgmt_subscription_id
#}


