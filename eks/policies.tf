data "aws_region" "current" {}


module "iam_policy_autoscaling_eks" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "4.3.0"

  name        = "${var.cluster_name}-autoscaling-eks"
  description = "${var.cluster_name} eks autoscaling"
  policy      = file("policies/autoscaling-eks.json")

  tags = merge({ "Environment" = var.environment }, { "Terraform" = "true" }, var.tags)
}

module "iam_policy_alb_eks_v2" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "4.3.0"

  name        = "${var.cluster_name}-alb-eks-v2"
  description = "${var.cluster_name} eks alb additional"
  policy      = file("policies/alb-eks-v2.json")

  tags = merge({ "Environment" = var.environment }, { "Terraform" = "true" }, var.tags)
}

module "iam_policy_fluent_bit_eks" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "4.3.0"

  name        = "${var.cluster_name}-fluent-bit-eks"
  description = "${var.cluster_name} Fluent-bit logs write access"
  policy      = file("policies/fluent-bit-eks.json")

  tags = merge({ "Environment" = var.environment }, { "Terraform" = "true" }, var.tags)
}

module "iam_policy_ebs_csi_eks" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "4.3.0"

  name        = "${var.cluster_name}-ebs-csi-eks"
  description = "${var.cluster_name} EBS CSI"
  policy      = file("policies/ebs-csi-eks.json")

  tags = merge({ "Environment" = var.environment }, { "Terraform" = "true" }, var.tags)
}

module "iam_policy_efs_csi_eks" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "4.3.0"

  name        = "${var.cluster_name}-efs-csi-eks"
  description = "${var.cluster_name} EFS CSI"
  policy      = file("policies/efs-csi-eks.json")

  tags = merge({ "Environment" = var.environment }, { "Terraform" = "true" }, var.tags)
}


# EKS cubbit pods policies

# certbot
data "aws_iam_policy_document" "certbot_karonte" {
  statement {
    sid       = "AllowR53List"
    actions   = ["route53:ListHostedZones", "route53:GetChange"]
    resources = ["*"]
  }
  statement {
    sid       = "AllowR53ChangeRecord"
    actions   = ["route53:ChangeResourceRecordSets"]
    resources = ["arn:aws:route53:::hostedzone/${var.karonte_zone_id}"]
  }
}

module "iam_policy_certbot" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "4.3.0"

  name        = "certbot"
  description = "R53 access policy for certbot"
  policy      = data.aws_iam_policy_document.certbot_karonte.json

  tags = merge({ "Environment" = var.environment }, { "Terraform" = "true" }, var.tags)
}


# claw
data "template_file" "policy_claw" {
  template = file("${path.module}/templates/s3-policy.json.tpl")

  vars = {
    bucket_name = "${var.cluster_name}-shards-${var.environment}-${data.aws_region.current.name}-1"
  }
}

module "iam_policy_claw" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "4.3.0"

  name        = "claw"
  description = "S3 access policy for claw"
  policy      = data.template_file.policy_claw.rendered

  tags = merge({ "Environment" = var.environment }, { "Terraform" = "true" }, var.tags)
}


# configuration
data "aws_iam_policy_document" "configuration" {
  statement {
    sid       = "AllowDynamoDBListCreate"
    actions   = ["dynamodb:List*", "dynamodb:CreateTable"]
    resources = ["arn:aws:dynamodb:${data.aws_region.current.name}:*:table/*"]
  }
  statement {
    sid = "AllowDynamoDBWrite"
    actions = [
      "dynamodb:Describe*",
      "dynamodb:Get*",
      "dynamodb:BatchGet*",
      "dynamodb:PutItem",
      "dynamodb:BatchWrite*",
      "dynamodb:Update*",
      "dynamodb:Delete*"
    ]
    resources = ["arn:aws:dynamodb:${data.aws_region.current.name}:*:table/configuration"]
  }
  statement {
    sid       = "AllowDynamoDBQuery"
    actions   = ["dynamodb:Query", "dynamodb:Scan"]
    resources = ["arn:aws:dynamodb:${data.aws_region.current.name}:*:table/configuration"]
  }
}

module "iam_policy_configuration" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "4.3.0"

  name        = "configuration"
  description = "DynamoDB acess policy for configuration"
  policy      = data.aws_iam_policy_document.configuration.json

  tags = merge({ "Environment" = var.environment }, { "Terraform" = "true" }, var.tags)
}


# coordinator
data "template_file" "policy_coordinator" {
  template = file("${path.module}/templates/s3-policy.json.tpl")

  vars = {
    bucket_name = "${var.cluster_name}-thumbnails-${var.environment}-${data.aws_region.current.name}"
  }
}

module "iam_policy_coordinator" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "4.3.0"

  name        = "coordinator"
  description = "S3 access policy for coordinator"
  policy      = data.template_file.policy_coordinator.rendered

  tags = merge({ "Environment" = var.environment }, { "Terraform" = "true" }, var.tags)
}


# karonte
module "iam_policy_karonte" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "4.3.0"

  name        = "karonte"
  description = "R53 access policy for karonte"
  policy      = data.aws_iam_policy_document.certbot_karonte.json

  tags = merge({ "Environment" = var.environment }, { "Terraform" = "true" }, var.tags)
}


# mailer
module "iam_policy_mailer" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "4.3.0"

  name        = "mailer"
  description = "SES access policy for metrics"
  policy      = file("policies/mailer.json")

  tags = merge({ "Environment" = var.environment }, { "Terraform" = "true" }, var.tags)
}


# metrics
data "aws_iam_policy_document" "metrics" {
  statement {
    sid       = "AllowESHttpAccess"
    actions   = ["es:ESHttp*"]
    resources = ["arn:aws:es:*:${data.aws_caller_identity.current.account_id}:domain/metrics/*"]
  }
}

module "iam_policy_metrics" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "4.3.0"

  name        = "metrics"
  description = "ES access policy for metrics"
  policy      = data.aws_iam_policy_document.metrics.json

  tags = merge({ "Environment" = var.environment }, { "Terraform" = "true" }, var.tags)
}


# storage
data "template_file" "policy_storage" {
  template = file("${path.module}/templates/s3-policy.json.tpl")

  vars = {
    bucket_name = "${var.cluster_name}-chunks-${var.environment}-${data.aws_region.current.name}-1"
  }
}

module "iam_policy_storage" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "4.3.0"

  name        = "storage"
  description = "S3 access policy for storage"
  policy      = data.template_file.policy_storage.rendered

  tags = merge({ "Environment" = var.environment }, { "Terraform" = "true" }, var.tags)
}

# EKS cubbit pod users with policies
/*
# karonte
data "aws_iam_user" "karonte" {
  user_name = "karonte"
}

data "aws_iam_policy_document" "cassandra_karonte" {
  statement {
    sid       = "AllowCassandraRead"
    actions   = ["cassandra:Select"]
    resources = ["arn:aws:cassandra:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:/keyspace/system*"]
  }
  statement {
    sid       = "AllowCassandraWrite"
    actions   = ["cassandra:Create", "cassandra:Modify", "cassandra:Select"]
    resources = [
      "arn:aws:cassandra:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:/keyspace/karonte",
      "arn:aws:cassandra:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:/keyspace/karonte/*"
    ]
  }
}

module "iam_policy_cassandra_karonte" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "4.3.0"

  name        = "cassandra-karonte"
  description = "Cassandra access policy for karonte user"
  policy      = data.aws_iam_policy_document.cassandra_karonte.json

  tags = merge({ "Environment" = var.environment }, { "Terraform" = "true" }, var.tags)
}

resource "aws_iam_user_policy_attachment" "karonte_cassandra" {
  user       = data.aws_iam_user.karonte.user_name
  policy_arn = module.iam_policy_cassandra_karonte.arn
}
*/