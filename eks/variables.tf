variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster. Also used as a prefix in names of related resources."
  default     = "cubbit"
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes version to use for the EKS cluster."
  default     = "1.21"
}

variable "ec2_instance_types" {
  type        = list(string)
  description = "Node group's instance type(s)."
  default     = ["t3.medium"]
}

variable "ec2_disk_size" {
  type        = string
  description = "Workers' disk size."
  default     = "40"
}

variable "desired_capacity" {
  type        = string
  description = "Desired number of workers."
  default     = "1"
}

variable "min_capacity" {
  type        = string
  description = "Min number of workers."
  default     = "1"
}

variable "max_capacity" {
  type        = string
  description = "Max number of workers."
  default     = "30"
}

variable "log_retention_days" {
  type        = string
  description = "EC2 instance type used for the EKS cluster."
  default     = "30"
}

variable "vpc_id" {
  type        = string
  description = "VPC where the cluster and workers will be deployed."
}

variable "public_subnets" {
  type        = list(string)
  description = "A list of public subnets to place the EKS cluster and workers within."
}

variable "private_subnets" {
  type        = list(string)
  description = "A list of private subnets to place the EKS cluster and workers within."
}

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)
  default     = []
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

variable "enable_custom_service_accounts" {
  type        = bool
  description = "If set to true cubbit service accounts will not be created.\n At their place a map of custom service account can be provided."
  default     = false
}

variable "custom_service_accounts" {
  type        = map(map(string))
  description = "A map of service accounts to be created with its role and linked policy.\n Example: \"key_name\" = { namespace = \"cubbit\", policy_arn = \"ARN\" }.\n Example of created role name: \"cluster_name-eks-key_name\".\n You have to provide the ARN of the policy for every service account."
  default     = {}
}

variable "karonte_zone_id" {
  type        = string
  description = ""
}

variable "project_name" {
  type        = string
  description = "Current project name. Used as input folder for manifests."
}

variable "namespace" {
  type        = string
  description = "Current namespace."
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

variable "example_test" {
  type = bool
  default = false
}