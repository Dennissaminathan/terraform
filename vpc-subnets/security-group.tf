# If `aws_default_security_group` is not defined, it would be created implicitly with access `0.0.0.0/0`
resource "aws_default_security_group" "default" {
  vpc_id = join("", aws_vpc.default.*.id)

  # To allow ssh access to internet
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow ssh connection to internet"
  }

  # To allow load balancer access to internet
  ingress {
    from_port   = 80 #http
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow http 80 access to internet"
  }

  # allow all outgoing traffic (default rule)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    module.this.tags,
    {
      "Name" = "sg${var.delimiter}default${var.delimiter}${module.this.id}"
    })
}

#security group to allow ssh connection from public subnets to private subnets[instances]
resource "aws_security_group" "aws_security_group" {
  vpc_id = join("", aws_vpc.default.*.id)

  # To allow ssh connections to public subnets from private subnets
  ingress {
    from_port   = 22 #ssh
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.public_subnet_cidr_block
    description = "Allow ssh connection to public subnets"
  }

  # To allow range of application ports from private subnet instances to public subnets
  ingress {
    from_port   = 8000 #tcp
    to_port     = 8100
    protocol    = "tcp"
    cidr_blocks = var.public_subnet_cidr_block
    description = "Range of application port to public subnet"
  }

  # To postgres access to private subnets
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidr_block
    description = "Allow postgres connection to private subnets"
  }

  # To EFS access to private subnets
  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidr_block
    description = "Allow EFS connection to private subnets"
  }

  # To allow ping connection to private subnets
  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow ping connection to private subnets"
  }

  # allow all outgoing traffic (default rule)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    module.this.tags,
    {
      "Name" = "sg${var.delimiter}${module.this.id}${var.delimiter}internal"
    })

}
