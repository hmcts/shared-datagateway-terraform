

# General
locals {
  location_abrv = lower(join("", regex("^([a-zA-Z]+).*\\s([a-zA-Z])[a-zA-Z]+$", var.location)))
  rg_name       = "${var.product}-${local.location_abrv}"
  common_tags   = module.ctags.common_tags
}


# Common tags
module "ctags" {
  source      = "github.com/hmcts/terraform-module-common-tags"
  builtFrom   = var.builtFrom
  environment = var.env
  product     = var.product
}
