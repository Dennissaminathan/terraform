module "this" {
  source = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.19.2"

  enabled             = var.enabled
  namespace           = var.namespace
  environment         = var.environment
  name                = var.name
  delimiter           = var.delimiter
  tags                = var.tags

}

variable "enabled" {
  description = "Set to false to prevent the module from creating any resources"
  default     = "true"
}

variable "namespace" {
  description = "Namespace (e.g. `cp` or `cloudposse`)"
  type        = string
  default   = "gsep"
}

variable "environment" {
  type        = string
  default     = "production"
  description = "Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT'"
}

variable "name" {
  type        = string
  default     = "app"
  description = "Solution name, e.g. 'app' or 'jenkins'"
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `namespace`, `stage`, `name` and `attributes`"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}
