resource "aws_acm_certificate" "default-cert" {
  private_key      = tls_private_key.default-key.private_key_pem
  certificate_body = tls_self_signed_cert.default-cert.cert_pem
}

resource "tls_private_key" "default-key" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "default-cert" {
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

/*resource "aws_acm_certificate" "default-cert" {
  domain_name               = aws_route53_zone.primary-zone.name
  subject_alternative_names = ["api.acme-project.com"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "cert-validation" {
  certificate_arn         = aws_acm_certificate.default-cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert-validation : record.fqdn]
}*/
