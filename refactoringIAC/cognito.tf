resource "aws_cognito_user_pool" "cms_acme_user_pool" {
  name                     = "cms_acme_user_pool"
  alias_attributes = ["preferred_username"]
  username_configuration {
    case_sensitive = false
  }

  schema {
    name                     = "email"
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true  # false for "sub"
    required                 = true # true for "sub"
    string_attribute_constraints {   # if it is a string
      min_length = 1                 # 10 for "birthdate"
      max_length = 2048              # 10 for "birthdate"
    }
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

resource "aws_cognito_user_pool_domain" "cms_acme_user_pool" {
  domain       = "cms-acme-poc"
  user_pool_id = aws_cognito_user_pool.cms_acme_user_pool.id
}

 resource "aws_cognito_user_pool_client" "cms_acme_user_pool" {
     name = "client"
     user_pool_id = aws_cognito_user_pool.cms_acme_user_pool.id
     prevent_user_existence_errors = "ENABLED"
     enable_token_revocation = true
     callback_urls                        = ["https://example.com/callback"]
     logout_urls                        = ["https://example.com/signout"]

  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["phone", "email", "openid", "profile", "aws.cognito.signin.user.admin"]

     token_validity_units  {
     refresh_token = "days"
     access_token = "hours"
     id_token = "hours"
 }

 refresh_token_validity = 30
 access_token_validity = 1
 id_token_validity = 1


     explicit_auth_flows = [
      "ALLOW_ADMIN_USER_PASSWORD_AUTH",
      "ALLOW_USER_SRP_AUTH",
      "ALLOW_REFRESH_TOKEN_AUTH"
      ]


 }

resource "aws_cognito_user_group" "EHR_maintainer" {
  name         = "EHR_maintainer"
  user_pool_id = aws_cognito_user_pool.cms_acme_user_pool.id
}

resource "aws_cognito_user_group" "Facility_System_Administrator" {
  name         = "Facility_System_Administrator"
  user_pool_id = aws_cognito_user_pool.cms_acme_user_pool.id
}

resource "aws_cognito_user_group" "Government_Care_Systems_Coordinator" {
  name         = "Government_Care_Systems_Coordinator"
  user_pool_id = aws_cognito_user_pool.cms_acme_user_pool.id
}