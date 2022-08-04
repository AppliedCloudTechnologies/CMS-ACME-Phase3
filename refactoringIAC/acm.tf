resource "aws_acm_certificate" "api_cert" {
  private_key      = tls_private_key.default-key.private_key_pem
  certificate_body = tls_self_signed_cert.api_cert.cert_pem

  tags = {
    Name = "ansong844-api-certificate"
  }
}

resource "tls_private_key" "default-key" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "api_cert" {
  private_key_pem       = tls_private_key.default-key.private_key_pem
  dns_names             = ["acme-project.com", "api.acme-project.com"]
  validity_period_hours = 8760
  early_renewal_hours   = 7680

  subject {
    common_name = "acme-project.com"
  }

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

/*resource "aws_acm_certificate" "api_cert" {
  domain_name               = aws_route53_zone.default_public_zone.name
  subject_alternative_names = ["api.acm-project.com"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "ansong844-api-certificate"
  }
}

resource "aws_acm_certificate_validation" "api_cert" {
  certificate_arn         = aws_acm_certificate.api_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.api_cert : record.fqdn]
}*/
