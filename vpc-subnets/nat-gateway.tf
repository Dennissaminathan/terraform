resource "aws_eip" "default" {
  count = local.public_nat_gateways_count
  vpc   = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "default" {
  count         = local.public_nat_gateways_count
  allocation_id = element(aws_eip.default.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  depends_on    = [aws_subnet.public]

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    module.this.tags,
    {
      "Name" = "ngw${var.delimiter}${module.this.id}"
      "Type" = var.public_type
    },
  )
}