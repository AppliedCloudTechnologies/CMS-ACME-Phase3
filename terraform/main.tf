terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}

resource "random_id" "id" {
	  byte_length = 8
}

output "Auth_URL"{
  value = "https://${aws_cognito_user_pool_domain.cms_acme_poc_v1.domain}.auth.us-east-1.amazoncognito.com/oauth2/authorize"
}

output "Client_ID_aka_Audience" {
  value = aws_cognito_user_pool_client.CognitoUserPoolClient.id  
}

output "Update-Patient-Status" {
  value = "${aws_apigatewayv2_stage.ApiGatewayV2Stage.invoke_url}api/patient-status"
}

output "Username" {
  value = aws_cognito_user.username.username
}

output "Password" {
  value = aws_cognito_user.username.password
  sensitive = true
}

resource "aws_iam_user" "IAMUser" {
    path = "/"
    name = "api"
}

resource "aws_iam_access_key" "IAMAccessKey" {
    status = "Active"
    user = aws_iam_user.IAMUser.name

depends_on = [aws_iam_user.IAMUser]

}

resource "aws_iam_user_policy_attachment" "IAMUser_api_attach" {
  user       = aws_iam_user.IAMUser.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"

depends_on = [aws_iam_user.IAMUser]

}

resource "aws_internet_gateway" "EC2InternetGateway" {
  vpc_id = aws_vpc.EC2VPC.id
}

resource "aws_subnet" "EC2Subnet" {
  availability_zone       = "us-east-1a"
  cidr_block              = "10.0.0.0/24"
  vpc_id                  = aws_vpc.EC2VPC.id
  map_public_ip_on_launch = false
}

resource "aws_subnet" "EC2Subnet2" {
  availability_zone       = "us-east-1b"
  cidr_block              = "10.0.1.0/24"
  vpc_id                  = aws_vpc.EC2VPC.id
  map_public_ip_on_launch = false
}

resource "aws_lb" "ElasticLoadBalancingV2LoadBalancer" {
  name               = "alb-cms-service"
  internal           = false
  load_balancer_type = "application"
  subnets = [
    aws_subnet.EC2Subnet.id,
    aws_subnet.EC2Subnet2.id
  ]
  security_groups = [
    "${aws_security_group.temp_sg.id}"
  ]
  ip_address_type = "ipv4"
  access_logs {
    enabled = false
    bucket  = ""
    prefix  = ""
  }
  idle_timeout               = "60"
  enable_deletion_protection = "false"
  enable_http2               = "true"
  depends_on                 = [aws_internet_gateway.EC2InternetGateway]
}

resource "aws_ecs_cluster" "ECSCluster" {
  name = "cms-acme-project"
}

resource "aws_dynamodb_table" "DynamoDBTable" {
  attribute {
    name = "pat_id"
    type = "S"
  }
  attribute {
    name = "prov_nbr"
    type = "S"
  }
  name           = "patient_status"
  hash_key       = "pat_id"
  range_key      = "prov_nbr"
  read_capacity  = 1
  write_capacity = 1
}

resource "aws_dynamodb_table" "dynamo_db_table" {
 attribute {
        name = "pat_id"
        type = "S"
    }
    attribute {
        name = "prov_nbr"
        type = "S"
    }
    attribute {
        name = "uuid"
        type = "S"
    }
    billing_mode = "PAY_PER_REQUEST"
    name = "patient_admit_out"
    hash_key = "uuid"
    global_secondary_index {
        name = "pat_id"
        hash_key = "pat_id"
        range_key = "prov_nbr"
        projection_type = "ALL"
        read_capacity = 0
        write_capacity = 0
    }
}

resource "aws_vpc" "EC2VPC" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  # default_route_table_id = aws_default_route_table.default_route_table_cms.id


}

resource "aws_lb_target_group" "ElasticLoadBalancingV2TargetGroup" {
  health_check {
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
    healthy_threshold   = 5
    matcher             = "200"
  }
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.EC2VPC.id
  name        = "temp-cms-target-group"
}

resource "aws_lb_target_group" "ElasticLoadBalancingV2TargetGroup2" {
  health_check {
    interval            = 30
    path                = "/info/status"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
    healthy_threshold   = 5
    matcher             = "200"
  }
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.EC2VPC.id
  name        = "ecs-cms-ac-cmsacmeservice"
}

resource "aws_lb_target_group" "ElasticLoadBalancingV2TargetGroup3" {
  health_check {
    interval            = 30
    path                = "/info/status"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
    healthy_threshold   = 5
    matcher             = "200"
  }
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.EC2VPC.id
  name        = "ecs-cms-ac-cms-acme-service"
}

resource "aws_lb_target_group" "ElasticLoadBalancingV2TargetGroup4" {
  health_check {
    interval            = 30
    path                = "/info/status"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
    healthy_threshold   = 5
    matcher             = "200"
  }
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.EC2VPC.id
  name        = "cms-amce-tg-port"
}

resource "aws_ecs_service" "ECSService" {
  enable_ecs_managed_tags = true
  name                    = "cms-amce-fargate-service"
  cluster                 = aws_ecs_cluster.ECSCluster.id
  load_balancer {
    target_group_arn = aws_lb_target_group.ElasticLoadBalancingV2TargetGroup4.id
    container_name   = "container-cms-api"
    container_port   = 8081
  }
  desired_count                      = 2
  launch_type                        = "FARGATE"
  platform_version                   = "LATEST"
  task_definition                    = aws_ecs_task_definition.ECSTaskDefinition.arn
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  #   iam_role                           = aws_iam_service_linked_role.IAMServiceLinkedRole5.id
  network_configuration {
    assign_public_ip = true
    security_groups = [
      "${aws_security_group.temp_sg.id}"
    ]
    subnets = [
      aws_subnet.EC2Subnet.id,
      aws_subnet.EC2Subnet2.id
    ]
  }
  health_check_grace_period_seconds = 60
  scheduling_strategy               = "REPLICA"
}

resource "aws_ecs_task_definition" "ECSTaskDefinition" {
  container_definitions = "[{\"name\":\"container-cms-api\",\"image\":\"${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/cms-acme:v1\",\"cpu\":0,\"portMappings\":[{\"containerPort\":8081,\"hostPort\":8081,\"protocol\":\"tcp\"}],\"essential\":true,\"environment\":[{\"name\":\"AWS_REGION\",\"value\":\"us-east-1\"},{\"name\":\"AWS_SECRET_KEY\",\"value\":\"${aws_iam_access_key.IAMAccessKey.secret}\"},{\"name\":\"AWS_ACCESS_KEY\",\"value\":\"${aws_iam_access_key.IAMAccessKey.id}\"},{\"name\":\"JWT_JWKS_URI\",\"value\":\"https://cognito-idp.us-east-1.amazonaws.com/${aws_cognito_user_pool.CognitoUserPool.id}/.well-known/jwks.json\"}],\"mountPoints\":[],\"volumesFrom\":[],\"logConfiguration\":{\"logDriver\":\"awslogs\",\"options\":{\"awslogs-group\":\"/ecs/task-def-cms-api\",\"awslogs-region\":\"us-east-1\",\"awslogs-stream-prefix\":\"ecs\"}}}]"
  family                = "task-def-cms-api"
  execution_role_arn    = aws_iam_role.IAMRole.arn
  network_mode          = "awsvpc"
  requires_compatibilities = [
    "FARGATE"
  ]
  cpu    = "512"
  memory = "1024"

    provisioner "local-exec" {
    command = "chmod +x seed_data.sh && ./seed_data.sh"
  }

depends_on = [
  aws_iam_access_key.IAMAccessKey,
  aws_cognito_user_pool.CognitoUserPool,
  aws_ecr_repository.ECRRepository,
  aws_cloudformation_stack.csv_import,
  aws_dynamodb_table.dynamo_db_table
]

}

resource "aws_iam_role" "IAMRole" {
  path                 = "/"
  name                 = "ecsTaskExecutionRole"
  assume_role_policy   = "{\"Version\":\"2008-10-17\",\"Statement\":[{\"Sid\":\"\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"ecs-tasks.amazonaws.com\"},\"Action\":\"sts:AssumeRole\"}]}"
  max_session_duration = 3600

}

locals {
  BucketName = "csvtoddblambdafunction${random_id.id.hex}"
}

resource "aws_cloudformation_stack" "csv_import" {
  name = "csv-import"

  capabilities = ["CAPABILITY_IAM", "CAPABILITY_AUTO_EXPAND"]

  parameters = {
    BucketName = "${local.BucketName}",
    FileName = "patient_admit_out.csv",
    DynamoDBTableName = "patient_admit_out"
  }

  template_body = <<STACK
{
"Parameters" : {
        "BucketName": {
            "Description": "Name of the S3 bucket you will deploy the CSV file to",
            "Type": "String",
            "ConstraintDescription": "must be a valid bucket name."
        },
        "FileName": {
            "Description": "Name of the S3 file (including suffix)",
            "Type": "String",
            "ConstraintDescription": "Valid S3 file name."
        },
        "DynamoDBTableName": {
            "Description": "Name of the dynamoDB table you will use",
            "Type": "String",
            "ConstraintDescription": "must be a valid dynamoDB name."
        }
    },
    "Resources": {
        "LambdaRole" : {
          "Type" : "AWS::IAM::Role",
          "Properties" : {
            "AssumeRolePolicyDocument": {
              "Version" : "2012-10-17",
              "Statement" : [
                {
                  "Effect" : "Allow",
                  "Principal" : {
                    "Service" : ["lambda.amazonaws.com","s3.amazonaws.com"]
                  },
                  "Action" : [
                    "sts:AssumeRole"
                  ]
                }
              ]
            },
            "Path" : "/",
            "ManagedPolicyArns":["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole","arn:aws:iam::aws:policy/AWSLambdaInvocation-DynamoDB","arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"],
            "Policies": [{
                        "PolicyName": "policyname",
                        "PolicyDocument": {
                                 "Version": "2012-10-17",
                                 "Statement": [{
                                    "Effect": "Allow",
                                         "Resource": "*",
                                           "Action": [
                                                      "dynamodb:PutItem",
                                                              "dynamodb:BatchWriteItem"
                                           ]
                                }]
                        }
                }]
          }
       },
        "CsvToDDBLambdaFunction": {
            "Type": "AWS::Lambda::Function",
            "Properties": {
                "Handler": "index.lambda_handler",
                "Role": {
                    "Fn::GetAtt": [
                        "LambdaRole",
                        "Arn"
                    ]
                },
                "Code": {
                    "ZipFile": {
                        "Fn::Join": [
                            "\n",
                            [
                                "import json",
                                "import boto3",
                                "import os",
                                "import csv",
                                "import codecs",
                                "import sys",
                                "",
                                "s3 = boto3.resource('s3')",
                                "dynamodb = boto3.resource('dynamodb')",
                                "",
                                "bucket = os.environ['bucket']",
                                "key = os.environ['key']",
                                "tableName = os.environ['table']",
                                "",
                                "def lambda_handler(event, context):",
                                "",
                                "",
                                "   #get() does not store in memory",
                                "   try:",
                                "       obj = s3.Object(bucket, key).get()['Body']",
                                "   except Exception as error:",
                                "       print(error)",
                                "       print(\"S3 Object could not be opened. Check environment variable. \")",
                                "   try:",
                                "       table = dynamodb.Table(tableName)",
                                "   except Exception as error:",
                                "       print(error)",
                                "       print(\"Error loading DynamoDB table. Check if table was created correctly and environment variable.\")",
                                "",
                                "   batch_size = 100",
                                "   batch = []",
                                "",
                                "   #DictReader is a generator; not stored in memory",
                                "   for row in csv.DictReader(codecs.getreader('utf-8-sig')(obj)):",
                                "      if len(batch) >= batch_size:",
                                "         write_to_dynamo(batch)",
                                "         batch.clear()",
                                "",
                                "      batch.append(row)",
                                "",
                                "   if batch:",
                                "      write_to_dynamo(batch)",
                                "",
                                "   return {",
                                "      'statusCode': 200,",
                                "      'body': json.dumps('Uploaded to DynamoDB Table')",
                                "   }",
                                "",
                                "",
                                "def write_to_dynamo(rows):",
                                "   try:",
                                "      table = dynamodb.Table(tableName)",
                                "   except Exception as error:",
                                "      print(error)",
                                "      print(\"Error loading DynamoDB table. Check if table was created correctly and environment variable.\")",
                                "",
                                "   try:",
                                "      with table.batch_writer() as batch:",
                                "         for i in range(len(rows)):",
                                "            batch.put_item(",
                                "               Item=rows[i]",
                                "            )",
                                "   except Exception as error:",
                                "      print(error)",
                                "      print(\"Error executing batch_writer\")"
                            ]
                        ]
                    }
                },
                "Runtime": "python3.7",
                "Timeout": 900,
                "MemorySize": 3008,
                "Environment" : {
                    "Variables" : {"bucket" : { "Ref" : "BucketName" }, "key" : { "Ref" : "FileName" },"table" : { "Ref" : "DynamoDBTableName" }}
                }
            }
        },

        "S3Bucket": {
            "DependsOn" : ["CsvToDDBLambdaFunction","BucketPermission"],
            "Type": "AWS::S3::Bucket",
            "Properties": {

                "BucketName": {"Ref" : "BucketName"},
                "AccessControl": "BucketOwnerFullControl",
                "NotificationConfiguration":{
                    "LambdaConfigurations":[
                        {
                            "Event":"s3:ObjectCreated:*",
                            "Function":{
                                "Fn::GetAtt": [
                                    "CsvToDDBLambdaFunction",
                                    "Arn"
                                ]
                            }
                        }
                    ]
                }
            }
        },
        "BucketPermission":{
            "Type": "AWS::Lambda::Permission",
            "Properties":{
                "Action": "lambda:InvokeFunction",
                "FunctionName":{"Ref" : "CsvToDDBLambdaFunction"},
                "Principal": "s3.amazonaws.com",
                "SourceAccount": {"Ref":"AWS::AccountId"}
            }
        }
    }
}
STACK

depends_on = [aws_dynamodb_table.dynamo_db_table]

}

resource "aws_iam_role_policy_attachment" "IAMRole_ecsTaskExecutionRole_AmazonEC2ContainerRegistryFullAccess" {
  role       = aws_iam_role.IAMRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_role_policy_attachment" "IAMRole_ecsTaskExecutionRole_CloudWatchLogsFullAccess" {
  role       = aws_iam_role.IAMRole.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_role_policy_attachment" "IAMRole_ecsTaskExecutionRole_AmazonECS_FullAccess" {
  role       = aws_iam_role.IAMRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

resource "aws_security_group" "temp_sg" {
  name        = "temp_sg"
  description = "temp_sg"
  vpc_id      = aws_vpc.EC2VPC.id

  ingress {
    description      = "temp_sg"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_ecr_repository" "ECRRepository" {
  name = "cms-acme"
  force_delete = true

    provisioner "local-exec" {
    working_dir = "../cms-acme-api"
    command = "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com && docker tag cms-acme:v1 ${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/cms-acme:v1 && docker push ${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/cms-acme:v1"
  }

}

resource "aws_lb_listener" "ElasticLoadBalancingV2Listener" {
  load_balancer_arn = aws_lb.ElasticLoadBalancingV2LoadBalancer.id
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.ElasticLoadBalancingV2TargetGroup4.id
    type             = "forward"
  }
}

resource "aws_default_route_table" "default_route_table_cms" {
  default_route_table_id = aws_vpc.EC2VPC.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.EC2InternetGateway.id
  }
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_cognito_user" "username" {
  user_pool_id = aws_cognito_user_pool.CognitoUserPool.id
  username     = "username"
  password = random_password.password.result

  attributes = {
    "email"          = "email@example.com"
    "email_verified" = "true"
    "facility_id"    = "31619"
  }

    depends_on = [aws_cognito_user_pool.CognitoUserPool]

}

resource "aws_cognito_user_pool_domain" "cms_acme_poc_v1" {
  domain       = "cms-acme-poc-${random_id.id.hex}"
  user_pool_id = aws_cognito_user_pool.CognitoUserPool.id
}

resource "aws_cognito_resource_server" "resource" {
  identifier = "http://cms-acme-api-server-recource"
  name       = "cms-acme-api-server-recource"

  scope {
    scope_name        = "patient-impact.read"
    scope_description = "read patient admit record"
  }

  scope {
    scope_name        = "patient-imact.update"
    scope_description = "update patient admin record"
  }

  user_pool_id = aws_cognito_user_pool.CognitoUserPool.id
}

resource "aws_cognito_user_pool" "CognitoUserPool" {
  name = "cms-acme-user-pool"
  password_policy {
    minimum_length                   = 8
    temporary_password_validity_days = 7
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
  }
  auto_verified_attributes = [
    "email"
  ]
  mfa_configuration = "OFF"
  email_configuration {

  }
  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  username_configuration {
    case_sensitive = false
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

  schema {
    name                     = "email"
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true # false for "sub"
    required                 = true # true for "sub"
    string_attribute_constraints {  # if it is a string
      min_length = 0                # 10 for "birthdate"
      max_length = 2048             # 10 for "birthdate"
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "facility_id"
    string_attribute_constraints {
      max_length = "256"
      min_length = "1"
    }
    required = false
  }

}

resource "aws_cognito_user_pool_client" "CognitoUserPoolClient" {
  user_pool_id = aws_cognito_user_pool.CognitoUserPool.id
  name         = "cms-acme-app"
  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }
  callback_urls                 = ["https://www.example.com/callback"]
  logout_urls                   = ["https://www.example.com/signout"]
  access_token_validity         = 60
  id_token_validity             = 60
  refresh_token_validity        = 30
  prevent_user_existence_errors = "ENABLED"
  explicit_auth_flows = [
    "ALLOW_ADMIN_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH"
  ]
  read_attributes = [
    "address",
    "birthdate",
    "custom:facility_id",
    "email",
    "email_verified",
    "family_name",
    "gender",
    "given_name",
    "locale",
    "middle_name",
    "name",
    "nickname",
    "phone_number",
    "phone_number_verified",
    "picture",
    "preferred_username",
    "profile",
    "updated_at",
    "website",
    "zoneinfo",
  ]
  write_attributes = [
    "address",
    "birthdate",
    "custom:facility_id",
    "email",
    "family_name",
    "gender",
    "given_name",
    "locale",
    "middle_name",
    "name",
    "nickname",
    "phone_number",
    "picture",
    "preferred_username",
    "profile",
    "updated_at",
    "website",
    "zoneinfo",
  ]

  allowed_oauth_flows = [
    "code",
    "implicit",
  ]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes = [
    "aws.cognito.signin.user.admin",
    "email",
    "openid",
    "phone",
    "profile",
  ]
  supported_identity_providers = [
    "COGNITO",
  ]

}

resource "aws_apigatewayv2_deployment" "ApiGatewayV2Deployment" {
  api_id      = aws_apigatewayv2_api.ApiGatewayV2Api.id
  description = "Automatic deployment triggered by changes to the Api configuration"

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_apigatewayv2_route.ApiGatewayV2Route,
    aws_apigatewayv2_route.ApiGatewayV2Route2
  ]

}

resource "aws_apigatewayv2_stage" "ApiGatewayV2Stage" {
  name   = "$default"
  api_id = aws_apigatewayv2_api.ApiGatewayV2Api.id

  default_route_settings {
    detailed_metrics_enabled = false
    throttling_burst_limit   = 5000
    throttling_rate_limit    = 10000
  }
  auto_deploy = true

}

resource "aws_apigatewayv2_api" "ApiGatewayV2Api" {
  api_key_selection_expression = "$request.header.x-api-key"
  protocol_type                = "HTTP"
  route_selection_expression   = "$request.method $request.path"
  name                         = "cms-acme-api-gateway"

}

resource "aws_apigatewayv2_route" "ApiGatewayV2Route" {
  api_id             = aws_apigatewayv2_api.ApiGatewayV2Api.id
  api_key_required   = false
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.ApiGatewayV2Authorizer.id
  route_key          = "PUT /api/patient-status"
  target             = "integrations/${aws_apigatewayv2_integration.ApiGatewayV2Integration.id}"
}

resource "aws_apigatewayv2_route" "ApiGatewayV2Route2" {
  api_id             = aws_apigatewayv2_api.ApiGatewayV2Api.id
  api_key_required   = false
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.ApiGatewayV2Authorizer.id
  route_key          = "GET /info/status"
  target             = "integrations/${aws_apigatewayv2_integration.ApiGatewayV2Integration2.id}"
}

resource "aws_apigatewayv2_integration" "ApiGatewayV2Integration" {
  api_id                 = aws_apigatewayv2_api.ApiGatewayV2Api.id
  connection_type        = "INTERNET"
  integration_method     = "PUT"
  integration_type       = "HTTP_PROXY"
  integration_uri        = "http://${aws_lb.ElasticLoadBalancingV2LoadBalancer.dns_name}/api/patient-status"
  timeout_milliseconds   = 30000
  payload_format_version = "1.0"
}

resource "aws_apigatewayv2_integration" "ApiGatewayV2Integration2" {
  api_id                 = aws_apigatewayv2_api.ApiGatewayV2Api.id
  connection_type        = "INTERNET"
  integration_method     = "GET"
  integration_type       = "HTTP_PROXY"
  integration_uri        = "http://${aws_lb.ElasticLoadBalancingV2LoadBalancer.dns_name}/info/status"
  timeout_milliseconds   = 30000
  payload_format_version = "1.0"
}

resource "aws_apigatewayv2_authorizer" "ApiGatewayV2Authorizer" {
  api_id          = aws_apigatewayv2_api.ApiGatewayV2Api.id
  authorizer_type = "JWT"
  identity_sources = [
    "$request.header.Authorization"
  ]
  name = "jwt-authorizer-cognito-cmsacme"
  jwt_configuration {
    audience = [
      aws_cognito_user_pool_client.CognitoUserPoolClient.id
    ]
    issuer = "https://${aws_cognito_user_pool.CognitoUserPool.endpoint}"
  }
}


