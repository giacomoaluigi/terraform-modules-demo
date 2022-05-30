module "alb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.0.0"

  use_name_prefix = true
  name            = "alb-${var.name}"
  description     = "Security group for alb ${var.name}"
  vpc_id          = var.vpc_id

  ingress_rules       = ["https-443-tcp", "http-80-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  egress_rules            = ["all-all"]
  egress_cidr_blocks      = ["0.0.0.0/0"]
  egress_ipv6_cidr_blocks = []

  tags = merge({ "Environment" = var.environment }, { "Terraform" = "true" }, var.tags)
}
