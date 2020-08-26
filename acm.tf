resource "aws_acm_certificate" "tlexample" {
  provider          = aws.us-east-1
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "tlexample" {
  provider                = aws.us-east-1
  certificate_arn         = aws_acm_certificate.tlexample.arn
  validation_record_fqdns = aws_route53_record.tlexample_cert_validation.*.fqdn
}
