module "ecs" {
  source = "./modules/ecs"
  aws_subnet_private1_id = module.vpc.aws_subnet_private1_id
  aws_subnet_private2_id = module.vpc.aws_subnet_private2_id
  aws_subnet_public1_id = module.vpc.aws_subnet_public1_id
  aws_subnet_public2_id = module.vpc.aws_subnet_public2_id
  aws_security_group_allow_all_traffic_id = module.vpc.aws_security_group_allow_all_traffic_id

  aws_efs_access_point_grafana_access_point = module.efs.aws_efs_access_point_grafana_access_point
  aws_efs_access_point_grafana_access_point_id = module.efs.aws_efs_access_point_grafana_access_point_id
  aws_efs_access_point_jenkins_access_point = module.efs.aws_efs_access_point_jenkins_access_point
  aws_efs_access_point_jenkins_access_point_id = module.efs.aws_efs_access_point_jenkins_access_point_id
  aws_efs_access_point_nexus_access_point = module.efs.aws_efs_access_point_nexus_access_point
  aws_efs_access_point_nexus_access_point_id = module.efs.aws_efs_access_point_nexus_access_point_id
  aws_efs_access_point_sonarqube_access_point = module.efs.aws_efs_access_point_sonarqube_access_point
  aws_efs_access_point_sonarqube_access_point_id = module.efs.aws_efs_access_point_sonarqube_access_point_id
  aws_efs_file_system_app_efs_data_id = module.efs.aws_efs_file_system_app_efs_data_id
  
  aws_lb_target_group_grafana_target_group_arn = module.lb.aws_lb_target_group_grafana_target_group_arn
  aws_lb_target_group_jenkins_target_group_arn = module.lb.aws_lb_target_group_jenkins_target_group_arn
  aws_lb_target_group_nexus_target_group_arn = module.lb.aws_lb_target_group_nexus_target_group_arn
  aws_lb_target_group_prometheus_target_group_arn = module.lb.aws_lb_target_group_prometheus_target_group_arn
  aws_lb_target_group_sonarqube_target_group_arn = module.lb.aws_lb_target_group_sonarqube_target_group_arn

  jenkins_image = var.jenkins_image
  grafana_image = var.grafana_image
  prometheus_image = var.prometheus_image
  sonarqube_image = var.sonarqube_image
  nexus_image = var.nexus_image
  ecs_task_execution_role_arn = var.ecs_task_execution_role_arn
  iam_instance_profile = var.iam_instance_profile
}

module "efs" {
  source = "./modules/efs"

  aws_subnet_private1_id = module.vpc.aws_subnet_private1_id
  aws_subnet_private2_id = module.vpc.aws_subnet_private2_id
  aws_security_group_allow_all_traffic_id = module.vpc.aws_security_group_allow_all_traffic_id
}

module "lb" {
  source = "./modules/lb"

  aws_vpc_app_vpc_id = module.vpc.aws_vpc_app_vpc_id
  aws_subnet_public1_id = module.vpc.aws_subnet_public1_id
  aws_subnet_public2_id = module.vpc.aws_subnet_public2_id
  aws_security_group_allow_all_traffic_id = module.vpc.aws_security_group_allow_all_traffic_id

  ssl_certificate = var.ssl_certificate
  domain_name = var.domain_name
}

module "route53" {
  source = "./modules/route53"

  aws_lb_app-alb_dns_name = module.lb.aws_lb_app-alb_dns_name
  aws_lb_app-alb_zone_id = module.lb.aws_lb_app-alb_zone_id

  domain_name = var.domain_name
}

module "vpc" {
  source = "./modules/vpc"
}