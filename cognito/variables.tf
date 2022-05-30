variable "user_pool_name" {
  type        = string
  description = "Cognito user pool name"
  default     = "kibana"
}

variable "user_pool_domain" {
  type        = string
  description = "Cognito user pool domain"
}

variable "identity_pool_name" {
  type        = string
  description = "Cognito identity pool name"
  default     = "kibana"
}