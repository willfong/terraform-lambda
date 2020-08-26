resource "aws_route53_zone" "tlexample" {
  name = var.domain_name
}

resource "aws_route53_record" "tlexample_www" {
  zone_id = aws_route53_zone.tlexample.zone_id
  name    = "www"
  type    = "CNAME"

  records = [
    "www.google.com"
  ]

  ttl = "3600"
}

resource "aws_route53_record" "tlexample" {
  name    = aws_api_gateway_domain_name.tlexample.domain_name
  type    = "A"
  zone_id = aws_route53_zone.tlexample.id

  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.tlexample.cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.tlexample.cloudfront_zone_id
  }
}

resource "aws_route53_record" "tlexample_cert_validation" {
  count   = length(aws_acm_certificate.tlexample.domain_validation_options)
  name    = element(aws_acm_certificate.tlexample.domain_validation_options.*.resource_record_name, count.index)
  type    = element(aws_acm_certificate.tlexample.domain_validation_options.*.resource_record_type, count.index)
  zone_id = aws_route53_zone.tlexample.id
  records = [element(aws_acm_certificate.tlexample.domain_validation_options.*.resource_record_value, count.index)]
  ttl     = 60
}
