# Terraform Block
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