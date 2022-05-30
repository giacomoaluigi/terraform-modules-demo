data "aws_caller_identity" "current" {}


locals {
  eks_service_accounts = {
    "cluster-autoscaler" = {
      namespace  = "kube-system",
      policy_arn = module.iam_policy_autoscaling_eks.arn
    }
    "cw-metrics" = {
      namespace  = "kube-system",
      policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
    }
    "aws-load-balancer-controller" = {
      namespace  = "kube-system",
      policy_arn = module.iam_policy_alb_eks_v2.arn
    }
    "fluent-bit" = {
      namespace  = "kube-system",
      policy_arn = module.iam_policy_fluent_bit_eks.arn
    }
    "ebs-csi" = {
      namespace  = "kube-system",
      policy_arn = module.iam_policy_ebs_csi_eks.arn
    }
    "efs-csi" = {
      namespace  = "kube-system",
      policy_arn = module.iam_policy_efs_csi_eks.arn
    }
  }
  cubbit_service_accounts = {
    "certbot" = {
      namespace  = var.namespace,
      policy_arn = module.iam_policy_certbot.arn
    }
    "claw" = {
      namespace  = var.namespace,
      policy_arn = module.iam_policy_claw.arn
    }
    "configuration" = {
      namespace  = var.namespace,
      policy_arn = module.iam_policy_configuration.arn
    }
    "coordinator" = {
      namespace  = var.namespace,
      policy_arn = module.iam_policy_coordinator.arn
    }
    "karonte" = {
      namespace  = var.namespace,
      policy_arn = module.iam_policy_karonte.arn
    }
    "mailer" = {
      namespace  = var.namespace,
      policy_arn = module.iam_policy_mailer.arn
    }
    "metrics" = {
      namespace  = var.namespace,
      policy_arn = module.iam_policy_metrics.arn
    }
    "storage" = {
      namespace  = var.namespace,
      policy_arn = module.iam_policy_storage.arn
    }
  }
}

data "aws_iam_policy_document" "eks" {
  for_each = var.enable_custom_service_accounts == true ? var.custom_service_accounts : merge(local.eks_service_accounts, local.cubbit_service_accounts)

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${each.value.namespace}:${each.key}"]
    }

    principals {
      identifiers = [module.eks.oidc_provider_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "eks" {
  for_each = var.enable_custom_service_accounts == true ? var.custom_service_accounts : merge(local.eks_service_accounts, local.cubbit_service_accounts)

  name               = "${var.cluster_name}-eks-${each.key}"
  assume_role_policy = data.aws_iam_policy_document.eks[each.key].json

  tags = merge({ "Environment" = var.environment }, { "Terraform" = "true" }, var.tags)
}

resource "aws_iam_role_policy_attachment" "eks" {
  for_each = var.enable_custom_service_accounts == true ? var.custom_service_accounts : merge(local.eks_service_accounts, local.cubbit_service_accounts)

  policy_arn = each.value.policy_arn
  role       = aws_iam_role.eks[each.key].name
}


resource "local_file" "eks_sa" {
  for_each = var.enable_custom_service_accounts == true ? var.custom_service_accounts : local.cubbit_service_accounts

  filename        = "${path.module}/../../../../../../../../${var.project_name}/k8s/${var.cluster_name}/serviceaccount/${each.key}.yaml"
  file_permission = "0644"
  content = yamlencode({
    apiVersion : "v1",
    kind : "ServiceAccount",
    metadata : {
      namespace : each.value.namespace,
      name : each.key,
      annotations : {
        "eks.amazonaws.com/role-arn" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.cluster_name}-eks-${each.key}"
      }
    }
  })
}
