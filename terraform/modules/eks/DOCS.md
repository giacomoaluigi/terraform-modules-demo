## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | 17.22.0 |
| <a name="module_iam_policy_alb_eks_v2"></a> [iam\_policy\_alb\_eks\_v2](#module\_iam\_policy\_alb\_eks\_v2) | terraform-aws-modules/iam/aws//modules/iam-policy | 4.3.0 |
| <a name="module_iam_policy_autoscaling_eks"></a> [iam\_policy\_autoscaling\_eks](#module\_iam\_policy\_autoscaling\_eks) | terraform-aws-modules/iam/aws//modules/iam-policy | 4.3.0 |
| <a name="module_iam_policy_certbot"></a> [iam\_policy\_certbot](#module\_iam\_policy\_certbot) | terraform-aws-modules/iam/aws//modules/iam-policy | 4.3.0 |
| <a name="module_iam_policy_claw"></a> [iam\_policy\_claw](#module\_iam\_policy\_claw) | terraform-aws-modules/iam/aws//modules/iam-policy | 4.3.0 |
| <a name="module_iam_policy_configuration"></a> [iam\_policy\_configuration](#module\_iam\_policy\_configuration) | terraform-aws-modules/iam/aws//modules/iam-policy | 4.3.0 |
| <a name="module_iam_policy_coordinator"></a> [iam\_policy\_coordinator](#module\_iam\_policy\_coordinator) | terraform-aws-modules/iam/aws//modules/iam-policy | 4.3.0 |
| <a name="module_iam_policy_ebs_csi_eks"></a> [iam\_policy\_ebs\_csi\_eks](#module\_iam\_policy\_ebs\_csi\_eks) | terraform-aws-modules/iam/aws//modules/iam-policy | 4.3.0 |
| <a name="module_iam_policy_efs_csi_eks"></a> [iam\_policy\_efs\_csi\_eks](#module\_iam\_policy\_efs\_csi\_eks) | terraform-aws-modules/iam/aws//modules/iam-policy | 4.3.0 |
| <a name="module_iam_policy_fluent_bit_eks"></a> [iam\_policy\_fluent\_bit\_eks](#module\_iam\_policy\_fluent\_bit\_eks) | terraform-aws-modules/iam/aws//modules/iam-policy | 4.3.0 |
| <a name="module_iam_policy_karonte"></a> [iam\_policy\_karonte](#module\_iam\_policy\_karonte) | terraform-aws-modules/iam/aws//modules/iam-policy | 4.3.0 |
| <a name="module_iam_policy_mailer"></a> [iam\_policy\_mailer](#module\_iam\_policy\_mailer) | terraform-aws-modules/iam/aws//modules/iam-policy | 4.3.0 |
| <a name="module_iam_policy_metrics"></a> [iam\_policy\_metrics](#module\_iam\_policy\_metrics) | terraform-aws-modules/iam/aws//modules/iam-policy | 4.3.0 |
| <a name="module_iam_policy_storage"></a> [iam\_policy\_storage](#module\_iam\_policy\_storage) | terraform-aws-modules/iam/aws//modules/iam-policy | 4.3.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [local_file.eks_sa](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_iam_policy_document.certbot_karonte](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.metrics](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [template_file.policy_claw](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.policy_coordinator](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.policy_storage](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster. Also used as a prefix in names of related resources. | `string` | `"cubbit"` | no |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | Kubernetes version to use for the EKS cluster. | `string` | `"1.21"` | no |
| <a name="input_custom_service_accounts"></a> [custom\_service\_accounts](#input\_custom\_service\_accounts) | A map of service accounts to be created with its role and linked policy.<br> Example: "key\_name" = { namespace = "cubbit", policy\_arn = "ARN" }.<br> Example of created role name: "cluster\_name-eks-key\_name".<br> You have to provide the ARN of the policy for every service account. | `map(map(string))` | `{}` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | Desired number of workers. | `string` | `"1"` | no |
| <a name="input_ec2_disk_size"></a> [ec2\_disk\_size](#input\_ec2\_disk\_size) | Workers' disk size. | `string` | `"40"` | no |
| <a name="input_ec2_instance_types"></a> [ec2\_instance\_types](#input\_ec2\_instance\_types) | Node group's instance type(s). | `list(string)` | <pre>[<br>  "t3.medium"<br>]</pre> | no |
| <a name="input_enable_custom_service_accounts"></a> [enable\_custom\_service\_accounts](#input\_enable\_custom\_service\_accounts) | If set to true cubbit service accounts will not be created.<br> At their place a map of custom service account can be provided. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Current environment. | `string` | n/a | yes |
| <a name="input_karonte_zone_id"></a> [karonte\_zone\_id](#input\_karonte\_zone\_id) | n/a | `string` | n/a | yes |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | EC2 instance type used for the EKS cluster. | `string` | `"30"` | no |
| <a name="input_map_accounts"></a> [map\_accounts](#input\_map\_accounts) | Additional AWS account numbers to add to the aws-auth configmap. | `list(string)` | `[]` | no |
| <a name="input_map_roles"></a> [map\_roles](#input\_map\_roles) | Additional IAM roles to add to the aws-auth configmap. | <pre>list(object({<br>    rolearn  = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_map_users"></a> [map\_users](#input\_map\_users) | Additional IAM users to add to the aws-auth configmap. | <pre>list(object({<br>    userarn  = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_max_capacity"></a> [max\_capacity](#input\_max\_capacity) | Max number of workers. | `string` | `"30"` | no |
| <a name="input_min_capacity"></a> [min\_capacity](#input\_min\_capacity) | Min number of workers. | `string` | `"1"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Current namespace. | `string` | n/a | yes |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | A list of private subnets to place the EKS cluster and workers within. | `list(string)` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Current project name. Used as input folder for manifests. | `string` | n/a | yes |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | A list of public subnets to place the EKS cluster and workers within. | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC where the cluster and workers will be deployed. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_controller_role_arn"></a> [alb\_controller\_role\_arn](#output\_alb\_controller\_role\_arn) | The ARN of the alb-controller role. |
| <a name="output_cluster_autoscaler_role_arn"></a> [cluster\_autoscaler\_role\_arn](#output\_cluster\_autoscaler\_role\_arn) | The ARN of the cluster-autoscaler role. |
| <a name="output_cluster_certificate_authority_data"></a> [cluster\_certificate\_authority\_data](#output\_cluster\_certificate\_authority\_data) | Nested attribute containing certificate-authority-data for your cluster. This is the base64 encoded certificate data required to communicate with your cluster. |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | The endpoint for your EKS Kubernetes API. |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | The name/id of the EKS cluster. Will block on cluster creation until the cluster is really ready. |
| <a name="output_cw_metrics_role_arn"></a> [cw\_metrics\_role\_arn](#output\_cw\_metrics\_role\_arn) | The ARN of the CW metrics role. |
| <a name="output_ebs_csi_role_arn"></a> [ebs\_csi\_role\_arn](#output\_ebs\_csi\_role\_arn) | The ARN of the ebs-csi role. |
| <a name="output_efs_csi_role_arn"></a> [efs\_csi\_role\_arn](#output\_efs\_csi\_role\_arn) | The ARN of the efs-csi role. |
| <a name="output_fluent_bit_role_arn"></a> [fluent\_bit\_role\_arn](#output\_fluent\_bit\_role\_arn) | The ARN of the fluent-bit role. |
| <a name="output_worker_security_group_id"></a> [worker\_security\_group\_id](#output\_worker\_security\_group\_id) | Security group ID attached to the EKS workers. |
