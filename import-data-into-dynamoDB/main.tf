// Cloning Terraform src code to /tmp/terraform_src...
 code has been checked out.

data "aws_caller_identity" "current" {
}


variable "bucket_name" {
  description = "Name of the S3 bucket you will deploy the CSV file to"
  type = string
}


variable "file_name" {
  description = "Name of the S3 file (including suffix)"
  type = string
}


variable "dynamo_db_table_name" {
  description = "Name of the dynamoDB table you will use"
  type = string
}


resource "aws_dynamodb_table" "dynamo_db_table" {
  name = var.dynamo_db_table_name
  billing_mode = "PAY_PER_REQUEST"
  attribute = [{'name': '"uuid"', 'type': '"S"'}]
  // CF Property(KeySchema) = [{'AttributeName': '"uuid"', 'KeyType': '"HASH"'}]
  tags = [{'Key': '"Name"', 'Value': 'var.dynamo_db_table_name'}]
}


resource "aws_iam_role" "lambda_role" {
  assume_role_policy = {
    Version = "2012-10-17"
    Statement = [{'Effect': '"Allow"', 'Principal': {'Service': ['"lambda.amazonaws.com"', '"s3.amazonaws.com"']}, 'Action': ['"sts:AssumeRole"']}]
  }
  path = "/"
  managed_policy_arns = ['"arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"', '"arn:aws:iam::aws:policy/AWSLambdaInvocation-DynamoDB"', '"arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"']
  force_detach_policies = [{'PolicyName': '"policyname"', 'PolicyDocument': {'Version': '"2012-10-17"', 'Statement': [{'Effect': '"Allow"', 'Resource': '"*"', 'Action': ['"dynamodb:PutItem"', '"dynamodb:BatchWriteItem"']}]}}]
}


resource "aws_lambda_function" "csv_to_ddb_lambda_function" {
  handler = "index.lambda_handler"
  role = aws_iam_role.lambda_role.arn
  code_signing_config_arn = {
    ZipFile = join("
", ["import json", "import boto3", "import os", "import csv", "import codecs", "import sys", "", "s3 = boto3.resource('s3')", "dynamodb = boto3.resource('dynamodb')", "", "bucket = os.environ['bucket']", "key = os.environ['key']", "tableName = os.environ['table']", "", "def lambda_handler(event, context):", "", "", "   #get() does not store in memory", "   try:", "       obj = s3.Object(bucket, key).get()['Body']", "   except Exception as error:", "       print(error)", "       print("S3 Object could not be opened. Check environment variable. ")", "   try:", "       table = dynamodb.Table(tableName)", "   except Exception as error:", "       print(error)", "       print("Error loading DynamoDB table. Check if table was created correctly and environment variable.")", "", "   batch_size = 100", "   batch = []", "", "   #DictReader is a generator; not stored in memory", "   for row in csv.DictReader(codecs.getreader('utf-8-sig')(obj)):", "      if len(batch) >= batch_size:", "         write_to_dynamo(batch)", "         batch.clear()", "", "      batch.append(row)", "", "   if batch:", "      write_to_dynamo(batch)", "", "   return {", "      'statusCode': 200,", "      'body': json.dumps('Uploaded to DynamoDB Table')", "   }", "", "", "def write_to_dynamo(rows):", "   try:", "      table = dynamodb.Table(tableName)", "   except Exception as error:", "      print(error)", "      print("Error loading DynamoDB table. Check if table was created correctly and environment variable.")", "", "   try:", "      with table.batch_writer() as batch:", "         for i in range(len(rows)):", "            batch.put_item(", "               Item=rows[i]", "            )", "   except Exception as error:", "      print(error)", "      print("Error executing batch_writer")"])
  }
  runtime = "python3.7"
  timeout = "900"
  memory_size = "3008"


  environment {
    variables = {
    bucket = var.bucket_name
    key = var.file_name
    table = var.dynamo_db_table_name
  }
  }
}


resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
  // CF Property(AccessControl) = "BucketOwnerFullControl"


  replication_configuration {
    // CF Property(LambdaConfigurations) = [{'Event': '"s3:ObjectCreated:*"', 'Function': 'aws_lambda_function.csv_to_ddb_lambda_function.arn'}]
  }
}


resource "aws_lambda_permission" "bucket_permission" {
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.csv_to_ddb_lambda_function.arn
  principal = "s3.amazonaws.com"
  source_account = data.aws_caller_identity.current.account_id
}

