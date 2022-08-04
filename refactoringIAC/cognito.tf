resource "aws_cognito_user_pool" "ecs_extension" {
  name                     = "ecs_extension"
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

  tags = {
    Name = "ansong844-user-pool"
  }
}

resource "aws_cognito_user_pool_domain" "ecs_extension" {
  domain       = "ansong-ecs-extension-userpool"
  user_pool_id = aws_cognito_user_pool.ecs_extension.id
}

resource "aws_cognito_user_pool_client" "ecs_extension" {
  name                                 = "client"
  user_pool_id                         = aws_cognito_user_pool.ecs_extension.id
  allowed_oauth_flows_user_pool_client = true
  callback_urls                        = ["https://api.acme-project.com"]
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["aws.cognito.signin.user.admin"]
  supported_identity_providers         = ["COGNITO"]
}

resource "aws_cognito_user" "user1" {
  user_pool_id             = aws_cognito_user_pool.ecs_extension.id
  username                 = "ansong844110"
  password                 = "testPW!!223344$$"
  message_action           = "SUPPRESS"
  desired_delivery_mediums = ["EMAIL"]

  attributes = {
    email = "ansong844110@testemail.com"
  }
}

resource "aws_cognito_identity_pool" "ecs_extension" {
  identity_pool_name               = "Cognito-Pool"
  allow_unauthenticated_identities = false
  allow_classic_flow               = false

  cognito_identity_providers {
    client_id               = aws_cognito_user_pool_client.ecs_extension.id
    provider_name           = aws_cognito_user_pool.ecs_extension.endpoint
    server_side_token_check = false
  }

  tags = {
    Name = "ansong844-identity-pool"
  }
}

resource "aws_cognito_user_pool_ui_customization" "ecs_extension" {
  css          = ".label-customizable {font-weight: 400;}"
  image_file   = filebase64("acme-cms.png")
  user_pool_id = aws_cognito_user_pool_domain.ecs_extension.user_pool_id
}
