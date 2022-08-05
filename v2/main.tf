terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "EC2SecurityGroup" {
  description = "Cms -Fargate to LB SecGroup"
  name        = "CmsFargateAlbSG"

  vpc_id = aws_vpc.EC2VPC.id
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 0
    protocol  = "-1"
    to_port   = 0
  }
  egress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 0
    protocol  = "-1"
    to_port   = 0
  }
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
    "${aws_security_group.EC2SecurityGroup.id}",
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

resource "aws_dynamodb_table" "DynamoDBTable2" {
  attribute {
    name = "pat_id"
    type = "S"
  }
  attribute {
    name = "prov_nbr"
    type = "S"
  }
  name           = "patient_status1"
  hash_key       = "pat_id"
  range_key      = "prov_nbr"
  read_capacity  = 1
  write_capacity = 1
}

resource "aws_dynamodb_table" "DynamoDBTable3" {
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
  name           = "patient_admit_out"
  hash_key       = "uuid"
  read_capacity  = 1
  write_capacity = 1
  global_secondary_index {
    name            = "pat_id"
    hash_key        = "pat_id"
    range_key       = "prov_nbr"
    projection_type = "ALL"
    read_capacity   = 1
    write_capacity  = 1
  }
}

resource "aws_dynamodb_table" "DynamoDBTable4" {
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
  name           = "patient_admit_out1"
  hash_key       = "uuid"
  read_capacity  = 1
  write_capacity = 1
  global_secondary_index {
    name            = "pat_id"
    hash_key        = "pat_id"
    range_key       = "prov_nbr"
    projection_type = "ALL"
    read_capacity   = 1
    write_capacity  = 1
  }
}

resource "aws_vpc" "EC2VPC" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"

}

resource "aws_security_group" "EC2SecurityGroup2" {
  description = "Security Group"
  name        = "cms-service-lb-to-container-secgroup"

  vpc_id = aws_vpc.EC2VPC.id
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 0
    protocol  = "tcp"
    to_port   = 65535
  }
  egress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 0
    protocol  = "-1"
    to_port   = 0
  }
}

resource "aws_security_group" "EC2SecurityGroup3" {
  description = "2022-08-03T09:28:05.280Z"
  name        = "cms-ac-3107"

  vpc_id = aws_vpc.EC2VPC.id
  ingress {
    security_groups = [
      "${aws_security_group.temp_sg.id}"
    ]
    from_port = 80
    protocol  = "tcp"
    to_port   = 80
  }
  egress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 0
    protocol  = "-1"
    to_port   = 0
  }
}

resource "aws_security_group" "EC2SecurityGroup4" {
  description = "2022-08-03T07:48:38.399Z"
  name        = "cms-ac-1084"

  vpc_id = aws_vpc.EC2VPC.id
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 80
    protocol  = "tcp"
    to_port   = 80
  }
  egress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 0
    protocol  = "-1"
    to_port   = 0
  }
}

resource "aws_security_group" "EC2SecurityGroup5" {
  description = "2022-08-03T10:26:10.525Z"
  name        = "servic-885"

  vpc_id = aws_vpc.EC2VPC.id
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 80
    protocol  = "tcp"
    to_port   = 80
  }
  egress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 0
    protocol  = "-1"
    to_port   = 0
  }
}

resource "aws_security_group" "EC2SecurityGroup6" {
  description = "2022-08-03T10:06:19.864Z"
  name        = "cmsacm-717"

  vpc_id = aws_vpc.EC2VPC.id
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 80
    protocol  = "tcp"
    to_port   = 80
  }
  egress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 0
    protocol  = "-1"
    to_port   = 0
  }
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

resource "aws_api_gateway_rest_api" "ApiGatewayRestApi" {
  name           = "Transfer Custom Identity Provider basic template API"
  description    = "API used for GetUserConfig requests"
  api_key_source = "HEADER"
  endpoint_configuration {
    types = [
      "REGIONAL"
    ]
  }

}

resource "aws_api_gateway_method" "ApiGatewayMethod" {
  rest_api_id      = "uy0e4n4ug9"
  resource_id      = "vmm3c4"
  http_method      = "GET"
  authorization    = "AWS_IAM"
  api_key_required = false
  request_parameters = {
    "method.request.header.Password"      = false,
    "method.request.querystring.protocol" = false,
    "method.request.querystring.sourceIp" = false
  }
}

resource "aws_apigatewayv2_route" "ApiGatewayV2Route" {
  api_id             = "ddr1vbpvl9"
  api_key_required   = false
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.ApiGatewayV2Authorizer.id
  route_key          = "PUT /api/patient-status"
  target             = "integrations/dz8dqg7"
}

resource "aws_apigatewayv2_route" "ApiGatewayV2Route2" {
  api_id             = "ddr1vbpvl9"
  api_key_required   = false
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.ApiGatewayV2Authorizer.id
  route_key          = "GET /info/status"
  target             = "integrations/sj8bv1g"
}

resource "aws_apigatewayv2_integration" "ApiGatewayV2Integration" {
  api_id                 = "ddr1vbpvl9"
  connection_type        = "INTERNET"
  integration_method     = "PUT"
  integration_type       = "HTTP_PROXY"
  integration_uri        = "http://alb-cms-service-1418322537.us-east-1.elb.amazonaws.com/api/patient-status"
  timeout_milliseconds   = 30000
  payload_format_version = "1.0"
}

resource "aws_apigatewayv2_integration" "ApiGatewayV2Integration2" {
  api_id                 = "ddr1vbpvl9"
  connection_type        = "INTERNET"
  integration_method     = "GET"
  integration_type       = "HTTP_PROXY"
  integration_uri        = "http://alb-cms-service-1418322537.us-east-1.elb.amazonaws.com/info/status"
  timeout_milliseconds   = 30000
  payload_format_version = "1.0"
}

resource "aws_apigatewayv2_authorizer" "ApiGatewayV2Authorizer" {
  api_id          = "ddr1vbpvl9"
  authorizer_type = "JWT"
  identity_sources = [
    "$request.header.Authorization"
  ]
  name = "jwt-authorizer-cognito-cmsacme"
  jwt_configuration {
    audience = [
      "3fefcd1ms0kpug0uch8kmgtmat"
    ]
    issuer = "https://cognito-idp.us-east-1.amazonaws.com/us-east-1_HwRgngsNx"
  }
}

resource "aws_api_gateway_model" "ApiGatewayModel" {
  rest_api_id  = "uy0e4n4ug9"
  name         = "Empty"
  description  = "This is a default empty schema model"
  schema       = <<EOF
{
  "$schema": "http://json-schema.org/draft-04/schema#",
  "title" : "Empty Schema",
  "type" : "object"
}
EOF
  content_type = "application/json"
}

resource "aws_api_gateway_model" "ApiGatewayModel2" {
  rest_api_id  = "uy0e4n4ug9"
  name         = "Error"
  description  = "This is a default error schema model"
  schema       = <<EOF
{
  "$schema" : "http://json-schema.org/draft-04/schema#",
  "title" : "Error Schema",
  "type" : "object",
  "properties" : {
    "message" : { "type" : "string" }
  }
}
EOF
  content_type = "application/json"
}

resource "aws_api_gateway_model" "ApiGatewayModel3" {
  rest_api_id  = "uy0e4n4ug9"
  name         = "UserConfigResponseModel"
  description  = "API response for GetUserConfig"
  schema       = "{\"$schema\":\"http://json-schema.org/draft-04/schema#\",\"title\":\"UserUserConfig\",\"type\":\"object\",\"properties\":{\"Role\":{\"type\":\"string\"},\"Policy\":{\"type\":\"string\"},\"HomeDirectory\":{\"type\":\"string\"},\"PublicKeys\":{\"type\":\"array\",\"items\":{\"type\":\"string\"}}}}"
  content_type = "application/json"
}

resource "aws_cognito_user_pool" "CognitoUserPool" {
  name = "cms-acme-user-pool"
  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }
}

resource "aws_cognito_user_pool_client" "CognitoUserPoolClient" {
  user_pool_id           = aws_cognito_user_pool.CognitoUserPool.id
  name                   = "cms-acme-app"
  refresh_token_validity = 30
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
    "zoneinfo"
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
    "zoneinfo"
  ]
  explicit_auth_flows = [
    "ALLOW_ADMIN_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH"
  ]
}

resource "aws_iam_service_linked_role" "ecs" {
  aws_service_name = "ecs.amazonaws.com"
}

resource "aws_ecs_service" "ECSService" {
  name    = "cms-amce-fargate-service"
  cluster = aws_ecs_cluster.ECSCluster.id
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
  deployment_minimum_healthy_percent = 0
  iam_role                           = aws_iam_service_linked_role.ecs.id
  network_configuration {
    assign_public_ip = true
    security_groups = [
      "${aws_security_group.EC2SecurityGroup.id}"
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
  container_definitions = "[{\"name\":\"container-cms-api\",\"image\":\"548622183842.dkr.ecr.us-east-1.amazonaws.com/cms-acme:v1\",\"cpu\":0,\"portMappings\":[{\"containerPort\":8081,\"hostPort\":8081,\"protocol\":\"tcp\"}],\"essential\":true,\"environment\":[{\"name\":\"AWS_REGION\",\"value\":\"us-east-1\"},{\"name\":\"AWS_SECRET_KEY\",\"value\":\"F7Du7CpvsrD92LjhJOM3MkuSqL38MaAgEhXtwdNJ\"},{\"name\":\"AWS_ACCESS_KEY\",\"value\":\"AKIAX7PDOFWRKO6XLY4L\"},{\"name\":\"JWT_JWKS_URI\",\"value\":\"https://cognito-idp.us-east-1.amazonaws.com/us-east-1_HwRgngsNx/.well-known/jwks.json\"}],\"mountPoints\":[],\"volumesFrom\":[],\"logConfiguration\":{\"logDriver\":\"awslogs\",\"options\":{\"awslogs-group\":\"/ecs/task-def-cms-api\",\"awslogs-region\":\"us-east-1\",\"awslogs-stream-prefix\":\"ecs\"}}}]"
  family                = "task-def-cms-api"
  execution_role_arn    = aws_iam_role.IAMRole.arn
  network_mode          = "awsvpc"
  requires_compatibilities = [
    "FARGATE"
  ]
  cpu    = "512"
  memory = "1024"
}

resource "aws_iam_role" "IAMRole" {
  path                 = "/"
  name                 = "ecsTaskExecutionRole"
  assume_role_policy   = "{\"Version\":\"2008-10-17\",\"Statement\":[{\"Sid\":\"\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"ecs-tasks.amazonaws.com\"},\"Action\":\"sts:AssumeRole\"}]}"
  max_session_duration = 3600

}

resource "aws_iam_service_linked_role" "IAMServiceLinkedRole" {
  aws_service_name = "ecs.amazonaws.com"
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