#General
variable "location" {
  type    = string
  default = "UK South"
}

variable "environment" {
  type = string
}

variable "subnet_prefix" {
  type = string
}

variable "hub_subscription_id" {
  type = string
}

variable "subnet_id" {
  type        = string
  description = "subnet id"
}

# Virtual Machine
variable "vmsize" {
  type        = string
  description = "Vm Instance size"
  default     = "Standard_D3_v2"
}

variable "vm_admin_username" {
  type        = string
  description = "ctsc vm admin username, defaults to 'ctscadmin'"
}

variable "ctsc_rg_location" {

}

variable "ctsc_rg_name" {

}

variable "admin_password" {
  type        = string
  description = "admin_password"
}

# General
variable "builtFrom" {
  type    = string
  default = "hmcts/ctsc-datagateway-terraform"
}

variable "product" {
  type    = string
  default = "ctsc"
}

variable "project" {
  type    = string
  default = "ctsc"
}

variable "env" {
  type = string
}



# General
locals {
  location_abrv        = lower(join("", regex("^([a-zA-Z]+).*\\s([a-zA-Z])[a-zA-Z]+$", var.location)))
  rg_name              = "${var.product}-${local.location_abrv}"
  common_tags          = module.ctags.common_tags
  resource_name_prefix = format("%s-%s-%s", var.project, var.environment, local.location_abrv)
}


# Common tags
module "ctags" {
  source      = "github.com/hmcts/terraform-module-common-tags"
  builtFrom   = var.builtFrom
  environment = var.env
  product     = var.product
}

