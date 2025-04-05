output "aws_lb_app-alb_dns_name" {
  value = aws_lb.app-alb.dns_name
}

output "aws_lb_app-alb_zone_id" {
  value = aws_lb.app-alb.zone_id
}

output "aws_lb_target_group_grafana_target_group_arn" {
  value = aws_lb_target_group.grafana_target_group.arn
}

output "aws_lb_target_group_jenkins_target_group_arn" {
  value = aws_lb_target_group.jenkins_target_group.arn
}

output "aws_lb_target_group_nexus_target_group_arn" {
  value = aws_lb_target_group.nexus_target_group.arn
}

output "aws_lb_target_group_prometheus_target_group_arn" {
  value = aws_lb_target_group.prometheus_target_group.arn
}

output "aws_lb_target_group_sonarqube_target_group_arn" {
  value = aws_lb_target_group.sonarqube_target_group.arn
}
