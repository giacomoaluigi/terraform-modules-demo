module "iam_policy_kibana_auth" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "4.1.0"

  name        = "kibana-auth"
  description = ""
  policy      = file("policies/kibana-auth.json")
}

module "iam_policy_kibana_unauth" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "4.1.0"

  name        = "kibana-unauth"
  description = ""
  policy      = file("policies/kibana-unauth.json")
}