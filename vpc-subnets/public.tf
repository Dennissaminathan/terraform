locals {
  public_count              = var.enabled && var.public_type == "public" ? length(var.public_availability_zones) : 0
  public_nat_gateways_count = 1
}

resource "aws_subnet" "public" {
  count             = local.public_count
  vpc_id            = join("", aws_vpc.default.*.id)
  availability_zone = var.public_availability_zones[count.index]
  cidr_block        = var.public_subnet_cidr_block[count.index]

  tags = merge(
    module.this.tags,
    {
      "Name" = "public-snet${var.delimiter}${module.this.id}${var.delimiter}${element(var.public_availability_zones, count.index)}"
      "AZ"   = element(var.public_availability_zones, count.index)
      "Type" = var.public_type
    },
  )
}

resource "aws_route_table" "public" {
  count  = 1
  vpc_id = join("", aws_vpc.default.*.id)

  tags = merge(
    module.this.tags,
    {
      "Name" = "rt${var.delimiter}public${var.delimiter}${module.this.id}"
      "Type" = var.public_type
    },
  )
}

resource "aws_route_table_association" "public" {
  count          = local.public_count
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = join("", aws_route_table.public.*.id)
  depends_on = [
    aws_subnet.public,
    aws_route_table.public,
  ]
}

resource "aws_route" "public" {
  count                  = 1
  route_table_id         = join("", aws_route_table.public.*.id)
  gateway_id             = join("", aws_internet_gateway.default.*.id)
  destination_cidr_block = "0.0.0.0/0"
  depends_on             = [aws_route_table.public]
}
