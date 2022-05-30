resource "aws_route53_record" "alb" {
  for_each = var.services

  allow_overwrite = true
  name            = lookup(each.value, "dns_name", each.key)
  type            = "A"
  zone_id         = var.zone_id

  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = true
  }
}
