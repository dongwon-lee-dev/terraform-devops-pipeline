output "aws_efs_access_point_grafana_access_point" {
  value = aws_efs_access_point.grafana_access_point
}

output "aws_efs_access_point_grafana_access_point_id" {
  value = aws_efs_access_point.grafana_access_point.id
}

output "aws_efs_access_point_jenkins_access_point" {
  value = aws_efs_access_point.jenkins_access_point
}

output "aws_efs_access_point_jenkins_access_point_id" {
  value = aws_efs_access_point.jenkins_access_point.id
}

output "aws_efs_access_point_nexus_access_point" {
  value = aws_efs_access_point.nexus_access_point
}

output "aws_efs_access_point_nexus_access_point_id" {
  value = aws_efs_access_point.nexus_access_point.id
}

output "aws_efs_access_point_sonarqube_access_point" {
  value = aws_efs_access_point.sonarqube_access_point
}

output "aws_efs_access_point_sonarqube_access_point_id" {
  value = aws_efs_access_point.sonarqube_access_point.id
}

output "aws_efs_file_system_app_efs_data_id" {
  value = aws_efs_file_system.app_efs_data.id
}
