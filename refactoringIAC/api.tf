resource "aws_apigatewayv2_domain_name" "http_ecs" {
  domain_name = "api.acme-project.com"

  domain_name_configuration {
    certificate_arn = aws_acm_certificate.api_cert.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }

  tags = {
    Usage = "ansong-api-domain"
  }
}

resource "aws_apigatewayv2_api" "http_ecs" {
  name                         = "http_ecs"
  protocol_type                = "HTTP"
  disable_execute_api_endpoint = true

  tags = {
    Usage = "ansong-http-api"
  }
}

resource "aws_apigatewayv2_integration" "http_ecs" {
  api_id               = aws_apigatewayv2_api.http_ecs.id
  integration_type     = "HTTP_PROXY"
  integration_uri      = aws_lb_listener.api_ecs.arn
  connection_type      = "VPC_LINK"
  integration_method   = "ANY"
  timeout_milliseconds = 10000
  credentials_arn      = aws_iam_role.api-nlb-integration.arn
  connection_id        = aws_apigatewayv2_vpc_link.http_ecs.id
}

resource "aws_apigatewayv2_route" "http_ecs" {
  api_id    = aws_apigatewayv2_api.http_ecs.id
  route_key = "ANY /http_ecs/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.http_ecs.id}"
}

resource "aws_apigatewayv2_deployment" "http_ecs" {
  api_id      = aws_apigatewayv2_api.http_ecs.id
  description = "http_ecs_deployment"

  triggers = {
    redeployment = sha1(join(",", tolist([
      jsonencode(aws_apigatewayv2_integration.http_ecs),
      jsonencode(aws_apigatewayv2_route.http_ecs),
    ])))
  }

  lifecycle {
    ignore_changes = [
      triggers
    ]
  }
}

resource "aws_apigatewayv2_stage" "http_ecs" {
  name          = "DefaultStage"
  api_id        = aws_apigatewayv2_api.http_ecs.id
  deployment_id = aws_apigatewayv2_deployment.http_ecs.id

  tags = {
    Usage = "ansong-api-default-stage"
  }

  #   lifecycle {
  #   prevent_destroy = true
  # }

}

resource "aws_apigatewayv2_vpc_link" "http_ecs" {
  name               = "http_ecs"
  security_group_ids = [aws_security_group.http_ecs.id]
  subnet_ids         = [aws_subnet.public1.id, aws_subnet.public2.id]

  tags = {
    Usage = "ansong-vpc-link"
  }
}

resource "aws_security_group" "http_ecs" {
  name   = "api_ecs_access"
  vpc_id = aws_vpc.api_ecs.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Usage = "ansong-vpc-link-sg"
  }
}

data "aws_iam_policy_document" "api-nlb-integration" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "api-nlb-integration" {
  name               = "api-nlb-integration"
  assume_role_policy = data.aws_iam_policy_document.api-nlb-integration.json

  tags = {
    Usage = "ansong-api-role"
  }
}

resource "aws_iam_role_policy_attachment" "api-nlb-integration" {
  role       = aws_iam_role.api-nlb-integration.name
  policy_arn = aws_iam_policy.api-nlb-integration.arn
}

resource "aws_iam_policy" "api-nlb-integration" {
  name = "api-nlb-integration"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:*",
        "elasticloadbalancing:DescribeListeners",
        "elasticloadbalancing:DescribeLoadBalancers",
        "elasticloadbalancing:DescribeRules",
        "elasticloadbalancing:DescribeTargetGroups"
      ],     
      "Resource": "*"
    }
  ]
}
EOF

  tags = {
    Usage = "ansong-api-policy"
  }
}