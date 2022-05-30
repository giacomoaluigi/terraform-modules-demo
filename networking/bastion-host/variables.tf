variable "vpc_id" {
  type        = string
  description = "VPC id."
  default     = ""
}

variable "subnets" {
  type        = list(string)
  description = "List of subnets."
}

variable "instance_type" {
  type        = string
  description = "Instance type."
  default     = "t3a.nano"
}

variable "allowed_ingress_cidr_blocks" {
  type        = list(string)
  description = "List of network subnets that are allowed."
  default = [
    "0.0.0.0/0"
  ]
}

variable "allowed_egress_cidr_blocks" {
  type        = list(string)
  description = "List of network subnets that are allowed."
  default = [
    "0.0.0.0/0"
  ]
}

variable "ssh_public_keys" {
  type        = list(string)
  description = "List of SSH public keys to install on bastion host."

  validation {
    condition = length(var.ssh_public_keys) > 0 && length([
      for k in var.ssh_public_keys : regex("^ssh-|^ecdsa-", k)
      ]) == length(var.ssh_public_keys) && length([
      for k in var.ssh_public_keys : true
      if length(k) > 80
    ]) == length(var.ssh_public_keys)
    error_message = "Provide at least one correct SSH public key."
  }
}

variable "zone_id" {
  type        = string
  description = "Route53 zone id."
}

variable "environment" {
  type        = string
  description = "Current environment."
}

variable "tags" {
  type        = map(string)
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`"
  default     = {}
}
