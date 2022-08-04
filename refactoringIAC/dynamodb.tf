resource "aws_dynamodb_table" "global_tables" {
  name             = "global-tables"
  billing_mode     = "PAY_PER_REQUEST"
  hash_key         = "UniqueID"
  table_class      = "STANDARD" #default
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"


  server_side_encryption {
    enabled = false
  }

  attribute {
    name = "UniqueID"
    type = "S"
  }

  replica {
    region_name = "us-east-1"
  }

  replica {
    region_name = "us-west-1"
  }

  tags = {
    Name = "ansong844-dynamodb-global-tables"
  }
}
