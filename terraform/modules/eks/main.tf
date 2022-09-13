module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.22.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = var.vpc_id
  subnets         = concat(var.public_subnets, var.private_subnets)

  cluster_create_security_group = true
  worker_create_security_group  = true
  worker_sg_ingress_from_port   = 0

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  manage_cluster_iam_resources = true
  manage_worker_iam_resources  = true

  cluster_enabled_log_types     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  cluster_log_retention_in_days = var.log_retention_days

  enable_irsa      = true
  write_kubeconfig = false
  manage_aws_auth  = true

  map_users    = var.map_users
  map_roles    = var.map_roles
  map_accounts = var.map_accounts

  node_groups_defaults = {
    subnets = var.private_subnets

    additional_tags = {
      "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
      "k8s.io/cluster-autoscaler/enabled"             = "true"
    }
  }

  node_groups = {
    "${var.cluster_name}-custom" = {
      name = "${var.cluster_name}-custom"
      k8s_labels = {
        nodetype = "${var.cluster_name}-custom"
      }

      create_launch_template = true
      ami_type               = "AL2_x86_64"
      disk_size              = var.ec2_disk_size
      disk_type              = "gp3"
      disk_encrypted         = true
      public_ip              = false

      instance_types   = var.ec2_instance_types
      desired_capacity = var.desired_capacity
      min_capacity     = var.min_capacity
      max_capacity     = var.max_capacity
    },
  }

  tags = merge({ "Environment" = var.environment }, { "Terraform" = "true" }, var.tags)
}
