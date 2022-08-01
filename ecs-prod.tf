resource "aws_ecs_cluster" "prod-cluster" {
  name = "prod-cluster"
}

resource "aws_ecs_cluster_capacity_providers" "prod-cluster-cp" {
  cluster_name = aws_ecs_cluster.prod-cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

resource "aws_ecs_task_definition" "prod-cluster-task" {
  family                   = "prod-cluster"
  requires_compatibilities = [var.cluster-launch-type]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.prod-task-execution-role.arn
  task_role_arn            = aws_iam_role.prod-task-execution-role.arn


  #MAKE APPROPRIATE CHANGES TO CPU, MEMORY, AND PORT SETTINGS
  container_definitions = <<TASK_DEFINITION
[
  {
    "name": "prod-container",
    "image": "${var.prod-container-image}",
    "cpu": 256,
    "memory": 512,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]
TASK_DEFINITION

  runtime_platform {
    operating_system_family = var.operating_system_family
    cpu_architecture        = var.cpu_architecture
  }

  ephemeral_storage {
    size_in_gib = 50
  }
}

resource "aws_ecs_service" "prod-cluster-service" {
  name                               = "prod-cluster-service"
  cluster                            = aws_ecs_cluster.prod-cluster.arn
  task_definition                    = aws_ecs_task_definition.prod-cluster-task.arn
  force_new_deployment               = false
  desired_count                      = 1
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  enable_execute_command             = true

  deployment_circuit_breaker {
    enable   = true
    rollback = false
  }

  capacity_provider_strategy {
    base              = 1
    capacity_provider = var.cluster-launch-type
    weight            = 100
  }

  network_configuration {
    subnets          = [aws_subnet.public-subnet.id, aws_subnet.public-subnet2.id]
    security_groups  = [aws_security_group.prod-sg.id]
    assign_public_ip = true
  }
}

resource "aws_security_group" "prod-sg" {
  name   = "prod-sg"
  vpc_id = aws_vpc.custom.id

  ingress {
    from_port   = var.prod-port
    to_port     = var.prod-port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_iam_policy_document" "prod-task-execution-role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "prod-task-execution-role" {
  name               = "prod-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.prod-task-execution-role.json
}

resource "aws_iam_role_policy_attachment" "prod-task-execution-role" {
  role       = aws_iam_role.prod-task-execution-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

