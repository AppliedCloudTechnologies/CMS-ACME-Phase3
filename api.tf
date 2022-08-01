resource "aws_api_gateway_domain_name" "api-domain" {
  domain_name              = "api.acme-project.com"
  regional_certificate_arn = aws_acm_certificate.default-cert.arn
  security_policy          = "TLS_1_2"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_rest_api" "rest-api" {
  name                         = "RESTAPI"
  disable_execute_api_endpoint = true

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

