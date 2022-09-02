resource "aws_security_group" "this" {
  name   = "${var.environment}-bastion"
  vpc_id = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = var.allowed_ingress_cidr_blocks
  }

  ingress {
    protocol    = "tcp"
    from_port   = 1122
    to_port     = 1124
    cidr_blocks = var.allowed_ingress_cidr_blocks
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = var.allowed_egress_cidr_blocks
  }

  tags = merge({ "Environment" = var.environment }, { "Terraform" = "true" }, var.tags)
}