resource "aws_vpc" "default" {
  count                            = local.enabled ? 1 : 0
  cidr_block                       = var.cidr_block
  instance_tenancy                 = var.instance_tenancy
  enable_dns_hostnames             = var.enable_dns_hostnames
  enable_dns_support               = var.enable_dns_support
  enable_classiclink               = var.enable_classiclink
  enable_classiclink_dns_support   = var.enable_classiclink_dns_support
  assign_generated_ipv6_cidr_block = true
  tags = merge(
    module.this.tags,
    {
      "Name" = "vpc${var.delimiter}${module.this.id}${var.delimiter}${var.region}"
    })
}

resource "aws_internet_gateway" "default" {
  count  = local.enable_internet_gateway
  vpc_id = join("", aws_vpc.default.*.id)
  tags   = merge(
    module.this.tags,
    {
      Name = "igw${var.delimiter}${module.this.id}"
    })
}

resource "aws_vpc_ipv4_cidr_block_association" "default" {
  for_each   = toset(local.additional_cidr_blocks)
  vpc_id     = join("", aws_vpc.default.*.id)
  cidr_block = each.key
}
