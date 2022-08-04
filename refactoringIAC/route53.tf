/*resource "aws_route53_zone" "default_public_zone" {
  name = "acme-project.com"
}*/

data "aws_route53_zone" "default_public_zone" {
  name         = "acme-project.com"
  private_zone = false
}

resource "aws_route53_record" "api_g" {
  zone_id = data.aws_route53_zone.default_public_zone.zone_id
  name    = aws_apigatewayv2_domain_name.http_ecs.domain_name
  type    = "A"

  alias {
    name                   = aws_apigatewayv2_domain_name.http_ecs.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.http_ecs.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}

/*resource "aws_route53_record" "api_cert" {
  for_each = {
    for dvo in aws_acm_certificate.api_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.default_public_zone.zone_id
}*/
