output "cluster_id" {
  description = "The name/id of the EKS cluster. Will block on cluster creation until the cluster is really ready."
  value       = module.eks.cluster_id
}

output "worker_security_group_id" {
  description = "Security group ID attached to the EKS workers."
  value       = module.eks.worker_security_group_id
}

output "cluster_endpoint" {
  description = "The endpoint for your EKS Kubernetes API."
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "Nested attribute containing certificate-authority-data for your cluster. This is the base64 encoded certificate data required to communicate with your cluster."
  value       = module.eks.cluster_certificate_authority_data
  sensitive   = true
}

output "cluster_autoscaler_role_arn" {
  description = "The ARN of the cluster-autoscaler role."
  value       = aws_iam_role.eks["cluster-autoscaler"].arn
}

output "cw_metrics_role_arn" {
  description = "The ARN of the CW metrics role."
  value       = aws_iam_role.eks["cw-metrics"].arn
}

output "alb_controller_role_arn" {
  description = "The ARN of the alb-controller role."
  value       = aws_iam_role.eks["aws-load-balancer-controller"].arn
}

output "fluent_bit_role_arn" {
  description = "The ARN of the fluent-bit role."
  value       = aws_iam_role.eks["fluent-bit"].arn
}

output "ebs_csi_role_arn" {
  description = "The ARN of the ebs-csi role."
  value       = aws_iam_role.eks["ebs-csi"].arn
}

output "efs_csi_role_arn" {
  description = "The ARN of the efs-csi role."
  value       = aws_iam_role.eks["efs-csi"].arn
}
