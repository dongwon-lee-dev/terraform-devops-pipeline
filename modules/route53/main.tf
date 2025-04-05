data "aws_route53_zone" "app_zone" {
  name = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "app_alb_alias" {
  zone_id = data.aws_route53_zone.app_zone.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.aws_lb_app-alb_dns_name
    zone_id                = var.aws_lb_app-alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "app_alb_cname" {
  zone_id = data.aws_route53_zone.app_zone.zone_id
  name    = "*.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [var.aws_lb_app-alb_dns_name]
}