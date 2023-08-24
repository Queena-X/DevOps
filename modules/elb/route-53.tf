resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = {
    Environment = "test"
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_route53_zone" "hosted_zone" {
  name = var.domain_name
}

resource "aws_route53_record" "devops_example" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = var.record_name
  type    = "CNAME"
  ttl     = 300
  records = [aws_lb.public-alb.dns_name]
}

resource "aws_acm_certificate_validation" "example" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.devops_example : record.fqdn]
}


