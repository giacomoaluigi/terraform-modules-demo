output "bastion_host_sg_id" {
  description = "The ID of the bastion_host_sg security group"
  value       = aws_security_group.this.id
}

output "bastion_public_ip" {
  value = aws_eip.bastion_host.public_ip
}

output "bastion_public_dns" {
  value = aws_eip.bastion_host.public_dns
}