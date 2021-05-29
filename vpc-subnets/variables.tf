variable "region" {
  description = "Region"
  type        = string
  default   = "eu-central-1"
}

##########################################################################
#                               VPC Variables                            #
##########################################################################

variable "cidr_block" {
  type        = string
  description = "Base CIDR block which is divided into subnet CIDR blocks (e.g. `10.0.0.0/16`)"
  default = "10.0.0.0/16"
}

variable "vpc_group_name" {
  type        = string
  description = "VPC group name"
  default     = "bastion-gsep-poc-stage"
}

variable "security_group_name" {
  type        = string
  description = "Security group name"
  default     = "sg-bastion-gsep-poc-stage"
}

variable "internet_gateway_name" {
  type        = string
  description = "Internet gateway name"
  default     = "igw-gsep-poc-stage"
}

variable "instance_tenancy" {
  type        = string
  description = "A tenancy option for instances launched into the VPC"
  default     = "default"
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "A boolean flag to enable/disable DNS hostnames in the VPC"
  default     = true
}

variable "enable_dns_support" {
  type        = bool
  description = "A boolean flag to enable/disable DNS support in the VPC"
  default     = true
}

variable "enable_classiclink" {
  type        = bool
  description = "A boolean flag to enable/disable ClassicLink for the VPC"
  default     = false
}

variable "enable_classiclink_dns_support" {
  type        = bool
  description = "A boolean flag to enable/disable ClassicLink DNS Support for the VPC"
  default     = false
}

variable "enable_default_security_group_with_custom_rules" {
  type        = bool
  description = "A boolean flag to enable/disable custom and restricive inbound/outbound rules for the default VPC's SG"
  default     = true
}

variable "enable_internet_gateway" {
  type        = bool
  description = "A boolean flag to enable/disable Internet Gateway creation"
  default     = true
}

variable "additional_cidr_blocks" {
  type        = list(string)
  description = "A list of additional IPv4 CIDR blocks to associate with the VPC"
  default     = null
}

##########################################################################
#                             Subnet Variables                           #
##########################################################################

variable "private_availability_zones" {
  type        = list(string)
  description = "List of Availability Zones (e.g. `['eu-west-1a', 'us-west-1b', 'us-west-1c']`)"
}

variable "public_availability_zones" {
  type        = list(string)
  description = "List of Availability Zones (e.g. `['eu-west-1a', 'us-west-1b', 'us-west-1c']`)"
}
variable "max_subnets" {
  default     = "6"
  description = "Maximum number of subnets that can be created. The variable is used for CIDR blocks calculation"
}

variable "type" {
  type        = string
  default     = "private"
  description = "Type of subnets to create (`private` or `public`)"
}

variable "public_type" {
  type        = string
  default     = "public"
  description = "Type of subnets to create (`private` or `public`)"
}

variable "private_subnet_cidr_block" {
  type        = list(string)
  description = "Base CIDR block which is divided into subnet CIDR blocks (e.g. `10.0.0.0/16`)"

}

variable "public_subnet_cidr_block" {
  type        = list(string)
  description = "Base CIDR block which is divided into subnet CIDR blocks (e.g. `10.0.0.0/16`)"

}

variable "ingress_allowed_ports" {
  type          = list(string)
  description   = "Allowed ssh port for accessing private subnet instances from public subnets"
  default       = ["22"]
}

variable "private_security_group_name" {
  type          = string
  description   = "Allowed ssh port for accessing private subnet instances from public subnets"
  default       = "sg-gsep-poc-private"
}

variable "az_ngw_ids" {
  type        = map(string)
  description = "Only for private subnets. Map of AZ names to NAT Gateway IDs that are used as default routes when creating private subnets"
  default     = {}
}

variable "public_network_acl_id" {
  type        = string
  description = "Network ACL ID that is added to the public subnets. If empty, a new ACL will be created"
  default     = ""
}

variable "private_network_acl_id" {
  type        = string
  description = "Network ACL ID that is added to the private subnets. If empty, a new ACL will be created"
  default     = ""
}

variable "public_network_acl_egress" {
  description = "Egress network ACL rules"
  type        = list(map(string))

  default = [
    {
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
    },
  ]
}

variable "public_network_acl_ingress" {
  description = "Egress network ACL rules"
  type        = list(map(string))

  default = [
    {
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
    },
  ]
}

variable "private_network_acl_egress" {
  description = "Egress network ACL rules"
  type        = list(map(string))

  default = [
    {
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
    },
  ]
}

variable "private_network_acl_ingress" {
  description = "Egress network ACL rules"
  type        = list(map(string))

  default = [
    {
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
    },
  ]
}

variable "nat_gateway_enabled" {
  description = "Flag to enable/disable NAT Gateways creation in public subnets"
  default     = "true"
}

variable "availability_zone_attribute_style" {
  description = "The style of Availability Zone code to use in tags and names. One of full, short, or fixed"
  default     = "full"
}
