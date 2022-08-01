provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket         = "acme-ecsfargate-terraform-remote-state-s3"
    key            = "terraform-backend/prod/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "acme-ecsfargate-terraform-remote-state-dynamoDB"
    encrypt        = true
  }
}
