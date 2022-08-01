resource "aws_dynamodb_table" "acme-user-table" {
  name         = "acme-user-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "UniqueID"
  table_class  = "STANDARD" #default


  server_side_encryption {
    enabled = true
  }

  attribute {
    name = "UniqueID"
    type = "S"
  }

   replica {
    region_name = "us-east-1"
  }

  replica {
    region_name = "us-west-2"
  }
}

resource "aws_dynamodb_table" "records" {
  name             = "acme-records-table"
  billing_mode     = "PAY_PER_REQUEST"
  hash_key         = "PrimaryID"
  table_class      = "STANDARD" #default
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"


  server_side_encryption {
    enabled = true
  }

  attribute {
    name = "PrimaryID"
    type = "S"
  }

  replica {
    region_name = "us-east-1"
  }

  replica {
    region_name = "us-west-2"
  }
}
