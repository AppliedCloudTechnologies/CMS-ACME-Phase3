resource "aws_wafv2_web_acl" "api_ecs" {
  name        = "api_ecs"
  description = "Only allow connections from US/US territory traffic."
  scope       = "REGIONAL"

  rule {
    name     = "api_ecs"
    priority = 1

    action {
      allow {}
    }

    statement {
      geo_match_statement {
        country_codes = ["US"]
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "random-name"
      sampled_requests_enabled   = false
    }
  }

  default_action {
    block {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "random-name"
    sampled_requests_enabled   = false
  }
}

resource "aws_wafv2_web_acl_association" "api-association" {
resource_arn = aws_apigatewayv2_stage.http_ecs.arn
web_acl_arn = aws_wafv2_web_acl.api_ecs.arn
}
