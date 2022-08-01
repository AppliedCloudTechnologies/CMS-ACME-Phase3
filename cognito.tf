resource "aws_cognito_user_pool" "default" {
  name                     = "default"
  auto_verified_attributes = ["email"]

  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE" #default
  }

  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }

    recovery_mechanism {
      name     = "verified_phone_number"
      priority = 2
    }
  }
}

resource "aws_cognito_user_pool_domain" "cognito" {
  domain       = "acme-userpool"
  user_pool_id = aws_cognito_user_pool.default.id
}

resource "aws_cognito_user_pool_client" "userpool_client" {
  name                                 = "client"
  user_pool_id                         = aws_cognito_user_pool.default.id
  allowed_oauth_flows_user_pool_client = true
  callback_urls                        = ["https://user-attachment.acme-project.com"]
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["aws.cognito.signin.user.admin"]
  supported_identity_providers         = ["COGNITO"]
}

resource "aws_cognito_user" "user1" {
  user_pool_id             = aws_cognito_user_pool.default.id
  username                 = "aansong"
  password                 = "testPW!!223344$$"
  message_action           = "SUPPRESS"
  desired_delivery_mediums = ["EMAIL"]

  attributes = {
    email = "aansong@collabralink.com"
  }
}

resource "aws_cognito_identity_pool" "default" {
  identity_pool_name               = "Cognito-Pool"
  allow_unauthenticated_identities = false
  allow_classic_flow               = false

  cognito_identity_providers {
    client_id               = aws_cognito_user_pool_client.userpool_client.id
    provider_name           = aws_cognito_user_pool.default.endpoint
    server_side_token_check = false
  }
}

resource "aws_cognito_user_pool_ui_customization" "example" {
  css          = ".label-customizable {font-weight: 400;}"
  image_file   = filebase64("acme-cms.png")
  user_pool_id = aws_cognito_user_pool_domain.cognito.user_pool_id
}
