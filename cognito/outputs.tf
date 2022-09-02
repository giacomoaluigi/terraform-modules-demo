output "user_pool_id" {
  value = aws_cognito_user_pool.kibana.id
}

output "identity_pool_id" {
  value = aws_cognito_identity_pool.kibana.id
}

output "role_authenticated" {
  value = aws_iam_role.kibana_limited_auth.arn
}

output "role_unauthenticated" {
  value = aws_iam_role.kibana_unauth.arn
}

output "kibana_endpoint_the_controprova" {
  value = aws_cognito_user_pool.kibana.endpoint
}