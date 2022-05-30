data "aws_elb_service_account" "main" {}
data "aws_caller_identity" "current" {}


locals {
  tg_binding = {
    path = "${path.module}/../../../../../../../../../../${var.project_name}/k8s/${var.cluster_name}/ingress"
  }
}


resource "aws_s3_bucket" "log_bucket" {
  bucket = "${var.name}-${var.environment}-alb-logs"
  acl    = "private"

  force_destroy = true
  policy = templatefile("${path.module}/alb-log-bucket-policy.json.tmpl",
    {
      bucket_name     = "${var.name}-${var.environment}-alb-logs",
      prefix          = "${var.name}-${var.environment}-alb"
      account_id      = data.aws_caller_identity.current.account_id
      elb_account_arn = data.aws_elb_service_account.main.arn
    }
  )

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = merge({ "Environment" = var.environment }, { "Terraform" = "true" }, var.tags)
}

resource "aws_s3_bucket_public_access_block" "log_bucket" {
  bucket = aws_s3_bucket.log_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_lb" "this" {
  name               = "${var.name}-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.alb_sg.security_group_id]
  idle_timeout       = var.idle_timeout

  access_logs {
    bucket  = aws_s3_bucket.log_bucket.bucket
    prefix  = "${var.name}-${var.environment}-alb"
    enabled = var.enable_logs
  }

  subnets = var.public_subnets

  tags = merge({ "Environment" = var.environment }, { "Terraform" = "true" }, var.tags)
}


resource "aws_lb_listener" "http_redirect" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  for_each = toset(var.listeners_port)

  load_balancer_arn = aws_lb.this.arn
  port              = each.value
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2020-10"
  certificate_arn   = var.certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "host header not valid"
      status_code  = "404"
    }
  }
}


resource "aws_lb_target_group" "cubbit_alb" {
  for_each = var.services

  name                 = "${var.name}-${each.key}"
  port                 = each.value.port
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = 300
  target_type          = "instance"

  health_check {
    protocol            = "HTTP"
    path                = lookup(each.value, "health_path", "/health")
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 15
    matcher             = lookup(each.value, "health_codes", "200")
  }

  stickiness {
    enabled         = var.enable_stickiness
    type            = "lb_cookie"
    cookie_duration = 60
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    { Name = "${var.name}-${each.key}" },
    { "Environment" = var.environment },
    { "Terraform" = "true" },
    var.tags
  )
}


resource "aws_lb_listener_rule" "cubbit_internal" {
  for_each = var.listener_rules_internal

  listener_arn = aws_lb_listener.https["443"].arn
  priority     = each.value.priority

  action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = "404"
    }
  }

  condition {
    path_pattern {
      values = [each.value.path]
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener_rule" "cubbit" {
  for_each = var.services

  listener_arn = aws_lb_listener.https["443"].arn
  priority     = each.value.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cubbit_alb[each.key].arn
  }

  condition {
    host_header {
      values = compact([
        "${lookup(each.value, "additional_host_header", "")}",
        "${lookup(each.value, "dns_name", each.key)}.${var.domain_url}"
      ])
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "local_file" "cubbit_tg_binding" {
  for_each = var.services

  filename        = "${local.tg_binding.path}/tg-binding-${each.key}.yaml"
  file_permission = "0644"
  content = yamlencode({
    apiVersion : "elbv2.k8s.aws/v1beta1",
    kind : "TargetGroupBinding",
    metadata : {
      namespace : lookup(each.value, "namespace", var.namespace),
      name : lookup(each.value, "name", "istio-ingressgateway-${each.key}")
    },
    spec : {
      serviceRef : {
        name : lookup(each.value, "name", "istio-ingressgateway"),
        port : tonumber(each.value.port)
      },
      targetGroupARN : aws_lb_target_group.cubbit_alb[each.key].arn,
      networking : {
        ingress : [{
          from : [{
            securityGroup : {
              groupID : module.alb_sg.security_group_id
            }
          }],
          ports : [{
            protocol : "TCP"
          }]
        }]
      }
    }
  })
}
