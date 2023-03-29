# General
locals {
  location_abrv = lower(join("", regex("^([a-zA-Z]+).*\\s([a-zA-Z])[a-zA-Z]+$", var.location)))
  rg_name       = "${var.project}-${local.location_abrv}-rg"
  common_tags   = module.ctags.common_tags
  nsg_name      = format("%s-%s-%s-nsg", var.project, var.environment, local.location_abrv)
  nsg_security_rules = [
    {
      name                       = "AllowAnyCustomOutbound"
      priority                   = 110
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_ranges    = ["443", "5671", "5672", "9350-9354"]
      source_address_prefixes    = [var.subnet_prefix]
      destination_address_prefix = "*"
      description                = "Allowing outbound traffic"
    }
  ]
}

# Common tags
module "ctags" {
  source      = "github.com/hmcts/terraform-module-common-tags"
  builtFrom   = var.builtFrom
  environment = var.buildEnv
  product     = var.product
}
