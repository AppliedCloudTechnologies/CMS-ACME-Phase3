output "api_gateway_endpoint" {
  value = aws_apigatewayv2_api.http_ecs.api_endpoint
}

output "nlb-dns-name" {
  value = aws_lb.api_ecs.dns_name
}