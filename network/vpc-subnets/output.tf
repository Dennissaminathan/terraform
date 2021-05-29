output "igw_id" {
  value       = join("", aws_internet_gateway.default.*.id)
  description = "The ID of the Internet Gateway"
}

output "vpc_id" {
  value       = join("", aws_vpc.default.*.id)
  description = "The ID of the VPC"
}

output "vpc_cidr_block" {
  value       = join("", aws_vpc.default.*.cidr_block)
  description = "The CIDR block of the VPC"
}

output "vpc_main_route_table_id" {
  value       = join("", aws_vpc.default.*.main_route_table_id)
  description = "The ID of the main route table associated with this VPC"
}

output "vpc_default_network_acl_id" {
  value       = join("", aws_vpc.default.*.default_network_acl_id)
  description = "The ID of the network ACL created by default on VPC creation"
}

output "vpc_default_security_group_id" {
  value       = aws_vpc.default.*.default_security_group_id
  description = "The ID of the security group created by default on VPC creation"
}

output "internal_security_group_ids" {
  value       = aws_security_group.aws_security_group.*.id
  description = "The ID of additional internal security group"
}

output "vpc_default_route_table_id" {
  value       = join("", aws_vpc.default.*.default_route_table_id)
  description = "The ID of the route table created by default on VPC creation"
}

output "vpc_ipv6_association_id" {
  value       = join("", aws_vpc.default.*.ipv6_association_id)
  description = "The association ID for the IPv6 CIDR block"
}

output "ipv6_cidr_block" {
  value       = join("", aws_vpc.default.*.ipv6_cidr_block)
  description = "The IPv6 CIDR block"
}

output "additional_cidr_blocks" {
  description = "A list of the additional IPv4 CIDR blocks associated with the VPC"
  value = [
    for i in aws_vpc_ipv4_cidr_block_association.default :
    i.cidr_block
    if local.additional_cidr_blocks_defined
  ]
}

output "additional_cidr_blocks_to_association_ids" {
  description = "A map of the additional IPv4 CIDR blocks to VPC CIDR association IDs"
  value = {
    for i in aws_vpc_ipv4_cidr_block_association.default :
    i.cidr_block => i.id
    if local.additional_cidr_blocks_defined
  }
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private.*.id
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public.*.id
}

output "az_private_subnet_ids" {
  value = zipmap(
    var.private_availability_zones,
    coalescelist(aws_subnet.private.*.id),
  )
  description = "Map of AZ names to subnet IDs"
}

output "az_public_subnet_ids" {
  value = zipmap(
    var.public_availability_zones,
    coalescelist(aws_subnet.public.*.id),
  )
  description = "Map of AZ names to subnet IDs"
}

output "az_private_subnet_arns" {
  value = zipmap(
    var.private_availability_zones,
    coalescelist(aws_subnet.private.*.arn),
  )
  description = "Map of AZ names to subnet ARNs"
}

output "az_public_subnet_arns" {
  value = zipmap(
    var.public_availability_zones,
    coalescelist(aws_subnet.public.*.arn),
  )
  description = "Map of AZ names to subnet ARNs"
}

output "private_subnet_cidr_block" {
  description = "List of private CIDR block"
  value       = aws_subnet.private.*.cidr_block
}

output "public_subnet_cidr_block" {
  description = "List of public CIDR bloack"
  value       = aws_subnet.public.*.cidr_block
}

output "private_route_table_ids" {
  description = "Private route table Ids"
  value = aws_route_table.private.*.id
}

output "public_route_table_ids" {
  description = "Public route table Ids"
  value = aws_route_table.public.*.id
}
