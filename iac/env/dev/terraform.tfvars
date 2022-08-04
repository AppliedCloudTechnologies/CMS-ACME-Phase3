# app/env to scaffold
app = "my-app"
environment = "dev"

container_port = "8080"
replicas = "1"
region = "us-east-1"
aws_profile = "default"
saml_role = "admin"
domain = "api.app.example.com"
zone = "app.example.com"
vpc = "vpc-123"
private_subnets = "subnet-123,subnet-456"
secrets_saml_users = []
tags = {
  application   = "my-app"
  environment   = "dev"
  team          = "my-team"
  customer      = "my-customer"
  contact-email = "me@example.com"
}
