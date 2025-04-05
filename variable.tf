variable "domain_name" {
  type        = string
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

variable "ssl_certificate" {
  type = string
}

variable "ecs_task_execution_role_arn" {
  type = string
}