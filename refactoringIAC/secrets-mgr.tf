
# YOU CAN SECURE MORE SECRETS USING THE BELOW CODE.

resource "aws_secretsmanager_secret" "ecs_extension" {
  name                    = "acme_extension"
  recovery_window_in_days = 30 #default

  tags = {
    Name = "ansong844-example-secret"
  }
}

resource "aws_secretsmanager_secret_version" "ecs_extension" {
  secret_id     = aws_secretsmanager_secret.ecs_extension.id
  secret_string = "AcmeTaskDefinition"
}

resource "aws_secretsmanager_secret_rotation" "ecs_extension" {
  secret_id           = aws_secretsmanager_secret.ecs_extension.id
  rotation_lambda_arn = aws_lambda_function.secrets_rotation.arn

  rotation_rules {
    automatically_after_days = 30
  }
}

resource "aws_lambda_function" "secrets_rotation" {
  # YOU CAN CLICK ON THE SECRET AFTER CREATION AND GET SAMPLE ROTATION CODE AT THE BOTTOM OF THE SCREEN. USE IT WITH THIS LAMBDA FUNCTION.
  description   = "Writes to DynamoDB tables after being triggered by API Gateway."
  function_name = "secrets_rotation"
  role          = aws_iam_role.secrets_rotation.arn
  runtime       = "python3.8"
  handler       = "rotation_code.lambda_handler"
  filename      = "rotation_code.zip"

  tags = {
    Name = "ansong844-secrets-rotation-lambda"
  }
}

resource "aws_lambda_permission" "secrets_rotation" {
  statement_id  = "AllowExecutionFromSecretManager"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.secrets_rotation.function_name
  principal     = "secretsmanager.amazonaws.com"
  source_arn    = aws_secretsmanager_secret.ecs_extension.arn
}

data "aws_iam_policy_document" "secrets_rotation" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "secrets_rotation" {
  name               = "secrets_rotation"
  assume_role_policy = data.aws_iam_policy_document.secrets_rotation.json

  tags = {
    Name = "ansong844-rotation-lambda-role"
  }
}

resource "aws_iam_role_policy_attachment" "secrets_rotation" {
  role       = aws_iam_role.secrets_rotation.name
  policy_arn = aws_iam_policy.secrets_rotation.arn
}

resource "aws_iam_policy" "secrets_rotation" {
  name = "secrets_rotation"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:PutSecretValue",
        "secretsmanager:UpdateSecretVersionStage",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "ec2:CreateNetworkInterface",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface",
        "ec2:AssignPrivateIpAddresses",
        "ec2:UnassignPrivateIpAddresses"
      ],      
      "Resource": "*"
    }
  ]
}
EOF

  tags = {
    Name = "ansong844-rotation-lambda-policy"
  }
}

