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

resource "aws_internet_gateway" "EC2InternetGateway" {
    vpc_id = "${aws_vpc.EC2VPC.id}"
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
  depends_on = [aws_internet_gateway.EC2InternetGateway]
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
  health_check_grace_period_seconds = 0
  scheduling_strategy               = "REPLICA"
}

resource "aws_ecs_task_definition" "ECSTaskDefinition" {
  container_definitions = "[{\"name\":\"container-cms-api\",\"image\":\"656862533084.dkr.ecr.us-east-1.amazonaws.com/cms-acme:v1\",\"cpu\":0,\"portMappings\":[{\"containerPort\":8081,\"hostPort\":8081,\"protocol\":\"tcp\"}],\"essential\":true,\"environment\":[],\"mountPoints\":[],\"volumesFrom\":[],\"logConfiguration\":{\"logDriver\":\"awslogs\",\"options\":{\"awslogs-group\":\"/ecs/task-def-cms-api\",\"awslogs-region\":\"us-east-1\",\"awslogs-stream-prefix\":\"ecs\"}}}]"
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
}

resource "aws_lb_listener" "ElasticLoadBalancingV2Listener" {
    load_balancer_arn = aws_lb.ElasticLoadBalancingV2LoadBalancer.id
    port = 80
    protocol = "HTTP"
    default_action {
        target_group_arn = aws_lb_target_group.ElasticLoadBalancingV2TargetGroup4.id
        type = "forward"
    }
}

resource "aws_default_route_table" "default_route_table_cms" {
  default_route_table_id = aws_vpc.EC2VPC.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.EC2InternetGateway.id
  }
 }

############################################
#######################
########################

resource "aws_cognito_user_pool" "CognitoUserPool" {
    name = "cms-acme-user-pool"
    password_policy {
        minimum_length = 8
        temporary_password_validity_days = 7
        require_lowercase = true
        require_numbers = true
        require_symbols = true
        require_uppercase = true
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
   
}

resource "aws_cognito_user_pool_client" "CognitoUserPoolClient" {
    user_pool_id = "${aws_cognito_user_pool.CognitoUserPool.id}"
    name = "cms-acme-app"
    refresh_token_validity = 30
    explicit_auth_flows = [
        "ALLOW_ADMIN_USER_PASSWORD_AUTH",
        "ALLOW_REFRESH_TOKEN_AUTH",
        "ALLOW_USER_SRP_AUTH"
    ]
}

resource "aws_apigatewayv2_deployment" "ApiGatewayV2Deployment" {
    api_id = "${aws_apigatewayv2_api.ApiGatewayV2Api.id}"
    description = "Automatic deployment triggered by changes to the Api configuration"

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_apigatewayv2_stage" "ApiGatewayV2Stage" {
    name = "$default"
    api_id = "${aws_apigatewayv2_api.ApiGatewayV2Api.id}"

    default_route_settings {
        detailed_metrics_enabled = false
    }
    auto_deploy = true
   
}

resource "aws_apigatewayv2_api" "ApiGatewayV2Api" {
    api_key_selection_expression = "$request.header.x-api-key"
    protocol_type = "HTTP"
    route_selection_expression = "$request.method $request.path"
    name = "cms-acme-api-gateway"
   
}

resource "aws_apigatewayv2_route" "ApiGatewayV2Route" {
    api_id = "${aws_apigatewayv2_api.ApiGatewayV2Api.id}"
    api_key_required = false
    authorization_type = "JWT"
    authorizer_id = "${aws_apigatewayv2_authorizer.ApiGatewayV2Authorizer.id}"
    route_key = "PUT /api/patient-status"
    target = "integrations/${aws_apigatewayv2_integration.ApiGatewayV2Integration.id}"
}

resource "aws_apigatewayv2_route" "ApiGatewayV2Route2" {
    api_id = "${aws_apigatewayv2_api.ApiGatewayV2Api.id}"
    api_key_required = false
    authorization_type = "JWT"
    authorizer_id = "${aws_apigatewayv2_authorizer.ApiGatewayV2Authorizer.id}"
    route_key = "GET /info/status"
    target = "integrations/${aws_apigatewayv2_integration.ApiGatewayV2Integration2.id}"
}

resource "aws_apigatewayv2_vpc_link" "example" {
  name               = "example"
  security_group_ids = [aws_security_group.temp_sg.id]
  subnet_ids         = [aws_subnet.EC2Subnet.id, aws_subnet.EC2Subnet.id]
}

resource "aws_apigatewayv2_integration" "ApiGatewayV2Integration" {
    api_id = "${aws_apigatewayv2_api.ApiGatewayV2Api.id}"
    connection_type    = "VPC_LINK"
    connection_id      = aws_apigatewayv2_vpc_link.example.id
    integration_method = "PUT"
    integration_type = "HTTP_PROXY"
    integration_uri = aws_lb_listener.ElasticLoadBalancingV2Listener.arn
    timeout_milliseconds = 30000
    payload_format_version = "1.0"
}

resource "aws_apigatewayv2_integration" "ApiGatewayV2Integration2" {
    api_id = "${aws_apigatewayv2_api.ApiGatewayV2Api.id}"
    connection_type    = "VPC_LINK"
    connection_id      = aws_apigatewayv2_vpc_link.example.id
    integration_method = "GET"
    integration_type = "HTTP_PROXY"
    integration_uri = aws_lb_listener.ElasticLoadBalancingV2Listener.arn
    timeout_milliseconds = 30000
    payload_format_version = "1.0"
}

resource "aws_apigatewayv2_authorizer" "ApiGatewayV2Authorizer" {
    api_id = aws_apigatewayv2_api.ApiGatewayV2Api.id
    authorizer_type = "JWT"
    identity_sources = [
        "$request.header.Authorization"
    ]
    name = "jwt-authorizer-cognito-cmsacme"
    jwt_configuration {
        audience = [
            "3fefcd1ms0kpug0uch8kmgtmat"
        ]
        issuer   = "https://${aws_cognito_user_pool.CognitoUserPool.endpoint}"
    }
}