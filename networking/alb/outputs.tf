output "alb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = aws_lb.this.name
}

output "alb_arn" {
  description = "ALB arn."
  value       = aws_lb.this.arn
}

output "target_group_arn" {
  description = "Map of target groups arn"

  value = tomap({
    for k, tg in aws_lb_target_group.cubbit_alb : k => tg.arn
  })
}

output "alb_arn_suffix" {
  description = "The ARN suffix for use with CloudWatch Metrics."
  value       = aws_lb.this.arn_suffix
}