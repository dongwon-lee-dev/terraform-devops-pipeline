variable "aws_efs_access_point_grafana_access_point" {
  type = any
}

variable "aws_efs_access_point_grafana_access_point_id" {
  type = string
}

variable "aws_efs_access_point_jenkins_access_point" {
  type = any
}

variable "aws_efs_access_point_jenkins_access_point_id" {
  type = string
}

variable "aws_efs_access_point_nexus_access_point" {
  type = any
}

variable "aws_efs_access_point_nexus_access_point_id" {
  type = string
}

variable "aws_efs_access_point_sonarqube_access_point" {
  type = any
}

variable "aws_efs_access_point_sonarqube_access_point_id" {
  type = string
}

variable "aws_efs_file_system_app_efs_data_id" {
  type = string
}

variable "aws_lb_target_group_grafana_target_group_arn" {
  type = string
}

variable "aws_lb_target_group_jenkins_target_group_arn" {
  type = string
}

variable "aws_lb_target_group_nexus_target_group_arn" {
  type = string
}

variable "aws_lb_target_group_prometheus_target_group_arn" {
  type = string
}
variable "aws_lb_target_group_sonarqube_target_group_arn" {
  type = string
}

variable "aws_security_group_allow_all_traffic_id" {
  type = string
}

variable "aws_subnet_private1_id" {
  type = string
}

variable "aws_subnet_private2_id" {
  type = string
}

variable "aws_subnet_public1_id" {
  type = string
}

variable "aws_subnet_public2_id" {
  type = string
}


variable "jenkins_image" {
  type = string
}

variable "grafana_image" {
  type = string
}

variable "prometheus_image" {
  type = string
}

variable "sonarqube_image" {
  type = string
}

variable "nexus_image" {
  type = string
}

variable "ecs_task_execution_role_arn" {
  type = string
}

variable iam_instance_profile {
  type = string
}