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

resource "aws_cognito_user_pool" "CognitoUserPool" {
  name = "cms-acme-user-pool"
  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
    temporary_password_validity_days = 7
  }
}

resource "aws_cognito_user_pool_client" "CognitoUserPoolClient" {
  user_pool_id           = aws_cognito_user_pool.CognitoUserPool.id
  name                   = "cms-acme-app"
  refresh_token_validity = 30
  explicit_auth_flows = [
    "ALLOW_ADMIN_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH"
  ]
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