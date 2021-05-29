locals {
  enabled                                         = module.this.enabled
  enable_default_security_group_with_custom_rules = var.enable_default_security_group_with_custom_rules && local.enabled ? 1 : 0
  enable_internet_gateway                         = var.enable_internet_gateway && local.enabled ? 1 : 0
  additional_cidr_blocks_defined                  = local.enabled && var.additional_cidr_blocks != null ? true : false
  additional_cidr_blocks                          = local.additional_cidr_blocks_defined ? var.additional_cidr_blocks : []
  private_availability_zones_count                 = local.enabled ? length(var.private_availability_zones) : 0
  public_availability_zones_count                 = local.enabled ? length(var.public_availability_zones) : 0
  enabled_count                                   = local.enabled ? 1 : 0
  delimiter                                       = module.this.delimiter
}

data "aws_availability_zones" "available" {
  count = local.enabled_count
}

module "utils" {
  source = "git::https://github.com/cloudposse/terraform-aws-utils.git?ref=tags/0.1.0"
}
