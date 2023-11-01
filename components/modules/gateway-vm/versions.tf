# Terraform Block
terraform {
  required_version = ">= 1.3.2"

  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = ">= 3.75.0"
      configuration_aliases = [azurerm.cnp, azurerm.soc]
    }
  }
}
