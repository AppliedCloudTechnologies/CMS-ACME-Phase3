resource "aws_ecs_cluster" "api_ecs" {
  name = "api_ecs"

  /*configuration {
    execute_command_configuration {
      logging = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.ecs_logging.name
      }
    }
  }*/

  tags = {
    Name = "ansong844-ecs-cluster"
  }
}

resource "aws_ecs_cluster_capacity_providers" "api_ecs-cp" {
  cluster_name = aws_ecs_cluster.api_ecs.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 2
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

resource "aws_ecs_task_definition" "api_ecs-task" {
  family                   = "api_ecs"
  requires_compatibilities = [var.cluster_launch_type]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.api_ecs.arn
  task_role_arn            = aws_iam_role.api_ecs.arn


  #MAKE APPROPRIATE CHANGES TO CPU, MEMORY, AND PORT SETTINGS
  container_definitions = <<TASK_DEFINITION
[
  {
    "name": "healthcare-container",
    "image": "${var.cont_image}",
    "cpu": 256,
    "memory": 512,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 8080,
        "hostPort": 8080
      }
    ]
  }
]
TASK_DEFINITION

  runtime_platform {
    operating_system_family = var.os_family
    cpu_architecture        = var.cpu_arch
  }

  ephemeral_storage {
    size_in_gib = 50
  }

  tags = {
    Name = "ansong844-ecs-task-definition"
  }
}

resource "aws_ecs_service" "api_ecs-service" {
  name                               = "api_ecs-service"
  cluster                            = aws_ecs_cluster.api_ecs.arn
  task_definition                    = aws_ecs_task_definition.api_ecs-task.arn
  force_new_deployment               = false
  desired_count                      = 2
  deployment_maximum_percent         = 300
  deployment_minimum_healthy_percent = 100
  enable_execute_command             = true

  deployment_circuit_breaker {
    enable   = true
    rollback = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.api_ecs.arn
    container_name   = "healthcare-container"
    container_port   = 8080
  }

  network_configuration {
    subnets          = [aws_subnet.public1.id, aws_subnet.public2.id]
    security_groups  = [aws_security_group.api_ecs.id]
    assign_public_ip = true
  }

  tags = {
    Name = "ansong844-ecs-service"
  }

  depends_on = [aws_lb_listener.api_ecs]
}

resource "aws_security_group" "api_ecs" {
  name   = "api_ecs"
  vpc_id = aws_vpc.api_ecs.id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ansong844-ecs-sg"
  }
}

data "aws_iam_policy_document" "api_ecs" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "api_ecs" {
  name               = "api_ecs"
  assume_role_policy = data.aws_iam_policy_document.api_ecs.json

  tags = {
    Name = "ansong844-ecs-role"
  }
}

resource "aws_iam_role_policy_attachment" "api_ecs" {
  role       = aws_iam_role.api_ecs.name
  policy_arn = aws_iam_policy.api_ecs.arn
}

resource "aws_iam_policy" "api_ecs" {
  name = "api_ecs"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:*",
        "logs:*",
        "cloudwatch:*",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "ssm:GetParametersByPath",
        "ssm:GetParameters",
        "ssm:GetParameter",
        "secretsmanager:DescribeSecret",
        "secretsmanager:GetSecretValue"
      ],      
      "Resource": "*"
    }
  ]
}
EOF

  tags = {
    Name = "ansong844-ecs-policy"
  }
}
