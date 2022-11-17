# Terraform Block
terraform {
  required_version = ">= 1.8.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.0"
    }
  }
}