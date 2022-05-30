## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_policy_kibana_auth"></a> [iam\_policy\_kibana\_auth](#module\_iam\_policy\_kibana\_auth) | terraform-aws-modules/iam/aws//modules/iam-policy | 4.1.0 |
| <a name="module_iam_policy_kibana_unauth"></a> [iam\_policy\_kibana\_unauth](#module\_iam\_policy\_kibana\_unauth) | terraform-aws-modules/iam/aws//modules/iam-policy | 4.1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cognito_identity_pool.kibana](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_identity_pool) | resource |
| [aws_cognito_user_pool.kibana](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool) | resource |
| [aws_cognito_user_pool_domain.kibana](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_domain) | resource |
| [aws_iam_role.kibana_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.kibana_limited_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.kibana_unauth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.kibana_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.kibana_limited_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.kibana_unauth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.cognito_kibana](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_identity_pool_name"></a> [identity\_pool\_name](#input\_identity\_pool\_name) | Cognito identity pool name | `string` | `"kibana"` | no |
| <a name="input_user_pool_domain"></a> [user\_pool\_domain](#input\_user\_pool\_domain) | Cognito user pool domain | `string` | n/a | yes |
| <a name="input_user_pool_name"></a> [user\_pool\_name](#input\_user\_pool\_name) | Cognito user pool name | `string` | `"kibana"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_identity_pool_id"></a> [identity\_pool\_id](#output\_identity\_pool\_id) | n/a |
| <a name="output_kibana_endpoint"></a> [kibana\_endpoint](#output\_kibana\_endpoint) | n/a |
| <a name="output_role_authenticated"></a> [role\_authenticated](#output\_role\_authenticated) | n/a |
| <a name="output_role_unauthenticated"></a> [role\_unauthenticated](#output\_role\_unauthenticated) | n/a |
| <a name="output_user_pool_id"></a> [user\_pool\_id](#output\_user\_pool\_id) | n/a |
