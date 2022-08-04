resource "aws_s3_bucket" "backend" {
  bucket = "ansong844110-backend-ecs-extension-project"

  tags = {
    Name = "ansong844-backend-bucket"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "backend-sse" {
  bucket = aws_s3_bucket.backend.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "backend-ver" {
  bucket = aws_s3_bucket.backend.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "state-lock" {
  name         = "state-lock-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "ansong844-state-lock-table"
  }
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
