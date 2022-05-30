resource "aws_cognito_user_pool" "kibana" {
  name                     = var.user_pool_name
  auto_verified_attributes = ["email"]
  mfa_configuration        = "OFF"

  schema {
    name                     = "email"
    attribute_data_type      = "String"
    required                 = "true"
    mutable                  = false
    developer_only_attribute = false
    string_attribute_constraints {
      min_length = 0
      max_length = 2048
    }
  }

  # TODO
  #email_configuration {
  #  email_sending_account = "DEVELOPER"
  #  source_arn            = local.ses_sender_identity
  #}

  password_policy {
    minimum_length                   = 8
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 2
  }

  admin_create_user_config {
    allow_admin_create_user_only = true
    invite_message_template {
      email_message = "Your username is {username} and temporary password is {####}. "
      email_subject = "Your Kibana Cognito temporary password"
      sms_message   = "Your username is {username} and temporary password is {####}. "
    }
  }

  verification_message_template {
    default_email_option  = "CONFIRM_WITH_CODE"
    email_subject         = "Your verification code"
    email_message         = "Your verification code is {####}. "
    email_subject_by_link = "Please verify your email"
    email_message_by_link = "To verify your account plase click here: {##Click Here##}"
    sms_message           = "Your verification code is {####}. "
  }

  user_pool_add_ons {
    advanced_security_mode = "AUDIT"
  }
}


resource "aws_cognito_user_pool_domain" "kibana" {
  domain       = var.user_pool_domain
  user_pool_id = aws_cognito_user_pool.kibana.id
}

resource "aws_cognito_identity_pool" "kibana" {
  identity_pool_name               = var.identity_pool_name
  allow_unauthenticated_identities = false

  lifecycle {
    ignore_changes = [cognito_identity_providers] # ignore elasticsearch cognito integration autoconfiguration
  }
}


data "aws_iam_policy_document" "cognito_kibana" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = ["cognito-identity.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "cognito-identity.amazonaws.com:aud"
      values   = [aws_cognito_identity_pool.kibana.id]
    }

    condition {
      test     = "ForAnyValue:StringLike"
      variable = "cognito-identity.amazonaws.com:amr"
      values   = ["authenticated"]
    }
  }
}

resource "aws_iam_role" "kibana_auth" {
  name               = "kibana-auth"
  assume_role_policy = data.aws_iam_policy_document.cognito_kibana.json
}

resource "aws_iam_role" "kibana_limited_auth" {
  name               = "kibana-limited-auth"
  assume_role_policy = data.aws_iam_policy_document.cognito_kibana.json
}

resource "aws_iam_role" "kibana_unauth" {
  name = "kibana-unauth"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "cognito-identity.amazonaws.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "cognito-identity.amazonaws.com:aud": "${aws_cognito_identity_pool.kibana.id}"
        },
        "ForAnyValue:StringLike": {
          "cognito-identity.amazonaws.com:amr": "unauthenticated"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "kibana_auth" {
  policy_arn = module.iam_policy_kibana_auth.arn
  role       = aws_iam_role.kibana_auth.name
}

resource "aws_iam_role_policy_attachment" "kibana_limited_auth" {
  policy_arn = module.iam_policy_kibana_auth.arn
  role       = aws_iam_role.kibana_limited_auth.name
}

resource "aws_iam_role_policy_attachment" "kibana_unauth" {
  policy_arn = module.iam_policy_kibana_unauth.arn
  role       = aws_iam_role.kibana_unauth.name
}