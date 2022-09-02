resource "aws_route53_record" "bh" {
  allow_overwrite = true
  name            = "bh"
  ttl             = "60"
  type            = "A"
  zone_id         = var.zone_id
  records         = [aws_eip.bastion_host.public_ip]
}
