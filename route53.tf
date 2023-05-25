resource "aws_route53_zone" "technonebulas" {
  name = "technonebulas.net"
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.acm.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
  ttl             = "300"

  # レコードを追加するドメインのホストゾーンIDを指定
  zone_id = aws_route53_zone.technonebulas.id
}

resource "aws_acm_certificate" "acm" {
  domain_name               = aws_route53_zone.technonebulas.name
  subject_alternative_names = ["*.${aws_route53_zone.technonebulas.name}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "acm_validation" {
  certificate_arn         = aws_acm_certificate.acm.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

