locals {
  private_count       = var.enabled == "true" && var.type == "private" ? length(var.private_availability_zones) : 0
  private_route_count = length(var.az_ngw_ids)
}

resource "aws_subnet" "private" {
  count             = local.private_count
  vpc_id            = join("", aws_vpc.default.*.id)
  availability_zone = var.private_availability_zones[count.index]
  cidr_block        = var.private_subnet_cidr_block[count.index]

  tags = merge(
    module.this.tags,
    {
      "Name" = "private-snet${var.delimiter}${module.this.id}${var.delimiter}${element(var.private_availability_zones, count.index)}"
      "AZ"   = var.private_availability_zones[count.index]
      "Type" = var.type
    },
  )
}

resource "aws_route_table" "private" {
  count  = 1
  vpc_id = join("", aws_vpc.default.*.id)

  tags = merge(
    module.this.tags,
    {
      "Name" = "rt${var.delimiter}private${var.delimiter}${module.this.id}"
      "Type" = var.type
    },
  )
}

resource "aws_route" "default" {
  count = local.private_route_count
  route_table_id = join("", aws_route_table.private.*.id)
  nat_gateway_id         = var.az_ngw_ids[element(keys(var.az_ngw_ids), count.index)]
  destination_cidr_block = "0.0.0.0/0"
  depends_on             = [aws_route_table.private]
}


resource "aws_route_table_association" "private" {
  count          = local.private_count
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = join("", aws_route_table.private.*.id)
  depends_on = [
    aws_subnet.private,
    aws_route_table.private,
  ]
}

resource "aws_route" "private" {
  count                  = 1
  route_table_id         = join("", aws_route_table.private.*.id)
  nat_gateway_id         = join("", aws_nat_gateway.default.*.id)
  destination_cidr_block = "0.0.0.0/0"
  depends_on             = [aws_route_table.private]
}
