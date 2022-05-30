variable "name" {
  type        = string
  description = "ALB name."
}

variable "idle_timeout" {
  type        = string
  description = "The time in seconds that the connection is allowed to be idle."
  default     = 60
}

variable "enable_stickiness" {
  type        = bool
  description = "Enable ALB sticky sessions."
  default     = false
}

variable "enable_logs" {
  type        = bool
  description = "Enable ALB logging on S3."
  default     = false
}

variable "vpc_id" {
  type        = string
  description = "VPC id."
}

variable "public_subnets" {
  type        = list(string)
  description = "A list of VPC subnet IDs for alb."
  default     = []
}

variable "listeners_port" {
  type        = list(string)
  description = "A list of alb listeners port."
  default     = ["443"]
}

variable "certificate_arn" {
  type        = string
  description = "ARN of default ACM certificate."
}

variable "cluster_name" {
  type        = string
  description = "Name/ID of the EKS cluster."
  default     = "cubbit"
}

variable "services" {
  type        = map(map(string))
  description = "ALB backend services to enable."
}

variable "listener_rules_internal" {
  type        = map(map(string))
  description = "Routes to block with ALB custom rules."
}

variable "domain_url" {
  type        = string
  description = "FQDN to be used on host matching rules."
}

variable "zone_id" {
  type        = string
  description = "Route53 zone id."
}

variable "project_name" {
  type        = string
  description = "Current project name. Used as input folder for manifests."
}

variable "namespace" {
  type        = string
  description = "Current EKS namespace."
}

variable "environment" {
  type        = string
  description = "Current environment."
}

variable "tags" {
  type        = map(string)
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`."
  default     = {}
}