module "ecs" {
  source = "./modules/ecs"
  aws_subnet_private1_id = module.vpc.aws_subnet_private1_id
  aws_subnet_private2_id = module.vpc.aws_subnet_private2_id
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


#resource "aws_vpc" "app-vpc" {
#  cidr_block = "10.0.0.0/16"
#  enable_dns_support   = true
#  enable_dns_hostnames = true
#  tags = {
#    Name = "app-vpc"
#  }
#}
#
#resource "aws_subnet" "public1" {
#  vpc_id = aws_vpc.app-vpc.id
#  cidr_block = "10.0.1.0/24"
#  map_public_ip_on_launch = true
#  availability_zone = "us-east-1a"
#}
#
#resource "aws_subnet" "public2" {
#  vpc_id = aws_vpc.app-vpc.id
#  cidr_block = "10.0.2.0/24"
#  map_public_ip_on_launch = true
#  availability_zone = "us-east-1b"
#}
#
#resource "aws_subnet" "private1" {
#  vpc_id = aws_vpc.app-vpc.id
#  cidr_block = "10.0.3.0/24"
#  map_public_ip_on_launch = false
#  availability_zone = "us-east-1a"
#}
#
#resource "aws_subnet" "private2" {
#  vpc_id = aws_vpc.app-vpc.id
#  cidr_block = "10.0.4.0/24"
#  map_public_ip_on_launch = false
#  availability_zone = "us-east-1b"
#}
#
#resource "aws_route_table" "public" {
#  vpc_id = aws_vpc.app-vpc.id
#}
#
#resource "aws_route_table" "private" {
#  vpc_id = aws_vpc.app-vpc.id
#}
#
#resource "aws_route_table_association" "public1" {
#  subnet_id = aws_subnet.public1.id
#  route_table_id = aws_route_table.public.id
#}
#
#resource "aws_route_table_association" "public2" {
#  subnet_id = aws_subnet.public2.id
#  route_table_id = aws_route_table.public.id
#}
#
#resource "aws_route_table_association" "private1" {
#  subnet_id = aws_subnet.private1.id
#  route_table_id = aws_route_table.private.id
#}
#
#resource "aws_route_table_association" "private2" {
#  subnet_id = aws_subnet.private2.id
#  route_table_id = aws_route_table.private.id
#}
#
#resource "aws_internet_gateway" "igt" {
#  vpc_id = aws_vpc.app-vpc.id
#}
#
#resource "aws_route" "igt_route" {
#  route_table_id = aws_route_table.public.id
#  destination_cidr_block = "0.0.0.0/0"
#  gateway_id = aws_internet_gateway.igt.id
#}
#
#resource "aws_eip" "nat_eip" {
#  domain = "vpc"
#}
#
#resource "aws_nat_gateway" "ngt" {
#  allocation_id = aws_eip.nat_eip.id
#  subnet_id     = aws_subnet.public1.id
#}
#
#resource "aws_route" "private_nat_access" {
#  route_table_id         = aws_route_table.private.id
#  destination_cidr_block = "0.0.0.0/0"
#  nat_gateway_id         = aws_nat_gateway.ngt.id
#}
#
#resource "aws_security_group" "allow_all_traffic" {
#  name        = "allow-all-sg"
#  description = "Allow all inbound and outbound traffic"
#  vpc_id      = aws_vpc.app-vpc.id
#
#  ingress {
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  egress {
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  tags = {
#    Name = "allow-all-sg"
#  }
#}
#
#// **********************************************************************
#
#resource "aws_efs_file_system" "app_efs_data" {
#  creation_token = "app_efs_data"
#  tags = {
#    Name = "app_efs_data"
#  }
#}
#
#resource "aws_efs_mount_target" "private1" {
#  file_system_id  = aws_efs_file_system.app_efs_data.id
#  subnet_id       = aws_subnet.private1.id
#  security_groups = [aws_security_group.allow_all_traffic.id]
#}
#
#resource "aws_efs_mount_target" "private2" {
#  file_system_id  = aws_efs_file_system.app_efs_data.id
#  subnet_id       = aws_subnet.private2.id
#  security_groups = [aws_security_group.allow_all_traffic.id]
#}
#
#resource "aws_efs_access_point" "jenkins_access_point" {
#  file_system_id = aws_efs_file_system.app_efs_data.id
#
#  posix_user {
#    uid = 1000
#    gid = 1000
#  }
#
#  root_directory {
#    path = "/jenkins"
#    creation_info {
#      owner_uid   = 1000
#      owner_gid   = 1000
#      permissions = "0777"
#    }
#  }
#
#  tags = {
#    Name = "jenkins-access-point"
#  }
#}
#
#resource "aws_efs_access_point" "grafana_access_point" {
#  file_system_id = aws_efs_file_system.app_efs_data.id
#
#  posix_user {
#    uid = 1000
#    gid = 1000
#  }
#
#  root_directory {
#    path = "/grafana"
#    creation_info {
#      owner_uid   = 1000
#      owner_gid   = 1000
#      permissions = "0777"
#    }
#  }
#
#  tags = {
#    Name = "grafana-access-point"
#  }
#}
#
#resource "aws_efs_access_point" "sonarqube_access_point" {
#  file_system_id = aws_efs_file_system.app_efs_data.id
#
#  posix_user {
#    uid = 1000
#    gid = 1000
#  }
#
#  root_directory {
#    path = "/sonarqube"
#    creation_info {
#      owner_uid   = 1000
#      owner_gid   = 1000
#      permissions = "0777"
#    }
#  }
#
#  tags = {
#    Name = "sonarqube-access-point"
#  }
#}
#
#resource "aws_efs_access_point" "nexus_access_point" {
#  file_system_id = aws_efs_file_system.app_efs_data.id
#
#  posix_user {
#    uid = 1000
#    gid = 1000
#  }
#
#  root_directory {
#    path = "/nexus"
#    creation_info {
#      owner_uid   = 1000
#      owner_gid   = 1000
#      permissions = "0777"
#    }
#  }
#
#  tags = {
#    Name = "nexus-access-point"
#  }
#}
#
#// **********************************************************************
#
#resource "aws_ecs_cluster" "app-cluster" {
#  name = "app-cluster"
#  setting {
#    name  = "containerInsights"
#    value = "enabled"
#  }
#}
#
#
#
#resource "aws_ecs_task_definition" "jenkins_master_with_efs" {
#  family                   = "jenkins-master"
#  requires_compatibilities = ["FARGATE"]
#  cpu                      = "2048"
#  memory                   = "4096"
#  network_mode             = "awsvpc"
#  execution_role_arn       = "arn:aws:iam::088351136602:role/ecsTaskExecutionRole"
#
#  runtime_platform {
#    cpu_architecture        = "X86_64"
#    operating_system_family = "LINUX"
#  }
#
#  volume {
#    name = "jenkins-data"
#    efs_volume_configuration {
#      file_system_id     = aws_efs_file_system.app_efs_data.id
#      root_directory     = "/"
#      transit_encryption = "ENABLED"
#      authorization_config {
#        access_point_id = aws_efs_access_point.jenkins_access_point.id
#        iam             = "DISABLED"
#      }
#    }
#  }
#
#  container_definitions = jsonencode([
#    {
#      name      = "jenkins",
#      image     = "088351136602.dkr.ecr.us-east-1.amazonaws.com/jenkins/jenkins:latest",
#      essential = true,
#      user      = "1000",
#      cpu       = 0,
#      portMappings = [
#        {
#          name          = "jenkins-8080-tcp",
#          containerPort = 8080,
#          hostPort      = 8080,
#          protocol      = "tcp",
#          appProtocol   = "http"
#        }
#      ],
#      mountPoints = [
#        {
#          sourceVolume  = "jenkins-data",
#          containerPath = "/var/jenkins_home",
#          readOnly      = false
#        }
#      ],
#      logConfiguration = {
#        logDriver = "awslogs",
#        options = {
#          awslogs-group         = "/ecs/jenkins-master",
#          mode                  = "non-blocking",
#          awslogs-create-group  = "true",
#          max-buffer-size       = "25m",
#          awslogs-region        = "us-east-1",
#          awslogs-stream-prefix = "ecs"
#        }
#      }
#    }
#  ])
#}
#
#resource "aws_ecs_service" "jenkins" {
#  name            = "jenkins-service"
#  cluster         = aws_ecs_cluster.app-cluster.id
#  task_definition = aws_ecs_task_definition.jenkins_master_with_efs.arn
#  launch_type     = "FARGATE"
#  desired_count   = 1
#
#  network_configuration {
#    subnets         = [aws_subnet.private1.id, aws_subnet.private2.id]
#    security_groups = [aws_security_group.allow_all_traffic.id]
#    assign_public_ip = false
#  }
#
#  load_balancer {
#    target_group_arn = aws_lb_target_group.jenkins_target_group.arn
#    container_name   = "jenkins"
#    container_port   = 8080
#  }
#
#  depends_on = [
#    aws_efs_access_point.jenkins_access_point
#  ]
#
#}
#
#resource "aws_appautoscaling_target" "jenkins" {
#  max_capacity       = 3
#  min_capacity       = 1
#  resource_id        = "service/${aws_ecs_cluster.app-cluster.name}/${aws_ecs_service.jenkins.name}"
#  scalable_dimension = "ecs:service:DesiredCount"
#  service_namespace  = "ecs"
#}
#
#resource "aws_appautoscaling_policy" "jenkins_cpu_scale_out" {
#  name               = "scale-out"
#  policy_type        = "TargetTrackingScaling"
#  resource_id        = aws_appautoscaling_target.jenkins.resource_id
#  scalable_dimension = aws_appautoscaling_target.jenkins.scalable_dimension
#  service_namespace  = aws_appautoscaling_target.jenkins.service_namespace
#
#  target_tracking_scaling_policy_configuration {
#    predefined_metric_specification {
#      predefined_metric_type = "ECSServiceAverageCPUUtilization"
#    }
#
#    target_value       = 60
#    scale_out_cooldown = 30
#    scale_in_cooldown  = 60
#  }
#}
#
#
#resource "aws_ecs_task_definition" "grafana_with_efs" {
#  family                   = "grafana"
#  requires_compatibilities = ["FARGATE"]
#  cpu                      = "1024"
#  memory                   = "2048"
#  network_mode             = "awsvpc"
#  execution_role_arn       = "arn:aws:iam::088351136602:role/ecsTaskExecutionRole"
#
#  runtime_platform {
#    cpu_architecture        = "X86_64"
#    operating_system_family = "LINUX"
#  }
#
#  volume {
#    name = "grafana-data"
#    efs_volume_configuration {
#      file_system_id     = aws_efs_file_system.app_efs_data.id
#      root_directory     = "/"
#      transit_encryption = "ENABLED"
#      authorization_config {
#        access_point_id = aws_efs_access_point.grafana_access_point.id
#        iam             = "DISABLED"
#      }
#    }
#  }
#
#  container_definitions = jsonencode([
#    {
#      name      = "grafana",
#      image     = "088351136602.dkr.ecr.us-east-1.amazonaws.com/grafana/grafana",
#      essential = true,
#      user      = "1000",
#      cpu       = 0,
#      portMappings = [
#        {
#          name          = "grafana-3000-tcp",
#          containerPort = 3000,
#          hostPort      = 3000,
#          protocol      = "tcp",
#          appProtocol   = "http"
#        }
#      ],
#      mountPoints = [
#        {
#          sourceVolume  = "grafana-data",
#          containerPath = "/var/lib/grafana",
#          readOnly      = false
#        }
#      ],
#      logConfiguration = {
#        logDriver = "awslogs",
#        options = {
#          awslogs-group         = "/ecs/grafana",
#          mode                  = "non-blocking",
#          awslogs-create-group  = "true",
#          max-buffer-size       = "25m",
#          awslogs-region        = "us-east-1",
#          awslogs-stream-prefix = "ecs"
#        }
#      }
#    }
#  ])
#}
#
#resource "aws_ecs_service" "grafana" {
#  name            = "grafana-service"
#  cluster         = aws_ecs_cluster.app-cluster.id
#  task_definition = aws_ecs_task_definition.grafana_with_efs.arn
#  launch_type     = "FARGATE"
#  desired_count   = 1
#
#  network_configuration {
#    subnets         = [aws_subnet.private1.id, aws_subnet.private2.id]
#    security_groups = [aws_security_group.allow_all_traffic.id]
#    assign_public_ip = false
#  }
#
#  load_balancer {
#    target_group_arn = aws_lb_target_group.grafana_target_group.arn
#    container_name   = "grafana"
#    container_port   = 3000
#  }
#
#  depends_on = [
#    aws_efs_access_point.grafana_access_point
#  ]
#
#}
#
#resource "aws_appautoscaling_target" "grafana" {
#  max_capacity       = 3
#  min_capacity       = 1
#  resource_id        = "service/${aws_ecs_cluster.app-cluster.name}/${aws_ecs_service.grafana.name}"
#  scalable_dimension = "ecs:service:DesiredCount"
#  service_namespace  = "ecs"
#}
#
#resource "aws_appautoscaling_policy" "grafana_cpu_scale_out" {
#  name               = "scale-out"
#  policy_type        = "TargetTrackingScaling"
#  resource_id        = aws_appautoscaling_target.grafana.resource_id
#  scalable_dimension = aws_appautoscaling_target.grafana.scalable_dimension
#  service_namespace  = aws_appautoscaling_target.grafana.service_namespace
#
#  target_tracking_scaling_policy_configuration {
#    predefined_metric_specification {
#      predefined_metric_type = "ECSServiceAverageCPUUtilization"
#    }
#
#    target_value       = 60
#    scale_out_cooldown = 30
#    scale_in_cooldown  = 60
#  }
#}
#
#resource "aws_ecs_task_definition" "sonarqube_with_efs" {
#  family                   = "sonarqube"
#  requires_compatibilities = ["FARGATE"]
#  cpu                      = "2048"
#  memory                   = "4096"
#  network_mode             = "awsvpc"
#  execution_role_arn       = "arn:aws:iam::088351136602:role/ecsTaskExecutionRole"
#
#  runtime_platform {
#    cpu_architecture        = "X86_64"
#    operating_system_family = "LINUX"
#  }
#
#  volume {
#    name = "sonarqube-data"
#    efs_volume_configuration {
#      file_system_id     = aws_efs_file_system.app_efs_data.id
#      root_directory     = "/"
#      transit_encryption = "ENABLED"
#      authorization_config {
#        access_point_id = aws_efs_access_point.sonarqube_access_point.id
#        iam             = "DISABLED"
#      }
#    }
#  }
#
#  container_definitions = jsonencode([
#    {
#      name      = "sonarqube",
#      image     = "088351136602.dkr.ecr.us-east-1.amazonaws.com/sonarqube",
#      essential = true,
#      user      = "1000",
#      cpu       = 0,
#      portMappings = [
#        {
#          name          = "sonarqube-9000-tcp",
#          containerPort = 9000,
#          hostPort      = 9000,
#          protocol      = "tcp",
#          appProtocol   = "http"
#        }
#      ],
#      mountPoints = [
#        {
#          sourceVolume  = "sonarqube-data",
#          containerPath = "/opt/sonarqube/data",
#          readOnly      = false
#        }
#      ],
#      logConfiguration = {
#        logDriver = "awslogs",
#        options = {
#          awslogs-group         = "/ecs/sonarqube",
#          mode                  = "non-blocking",
#          awslogs-create-group  = "true",
#          max-buffer-size       = "25m",
#          awslogs-region        = "us-east-1",
#          awslogs-stream-prefix = "ecs"
#        }
#      }
#    }
#  ])
#}
#
#resource "aws_ecs_service" "sonarqube" {
#  name            = "sonarqube-service"
#  cluster         = aws_ecs_cluster.app-cluster.id
#  task_definition = aws_ecs_task_definition.sonarqube_with_efs.arn
#  launch_type     = "FARGATE"
#  desired_count   = 1
#
#  network_configuration {
#    subnets         = [aws_subnet.private1.id, aws_subnet.private2.id]
#    security_groups = [aws_security_group.allow_all_traffic.id]
#    assign_public_ip = false
#  }
#
#  load_balancer {
#    target_group_arn = aws_lb_target_group.sonarqube_target_group.arn
#    container_name   = "sonarqube"
#    container_port   = 9000
#  }
#
#  depends_on = [
#    aws_efs_access_point.sonarqube_access_point
#  ]
#
#}
#
#resource "aws_ecs_task_definition" "nexus_with_efs" {
#  family                   = "nexus"
#  requires_compatibilities = ["FARGATE"]
#  cpu                      = "1024"
#  memory                   = "2048"
#  network_mode             = "awsvpc"
#  execution_role_arn       = "arn:aws:iam::088351136602:role/ecsTaskExecutionRole"
#
#  runtime_platform {
#    cpu_architecture        = "X86_64"
#    operating_system_family = "LINUX"
#  }
#
#  volume {
#    name = "nexus-data"
#    efs_volume_configuration {
#      file_system_id     = aws_efs_file_system.app_efs_data.id
#      root_directory     = "/"
#      transit_encryption = "ENABLED"
#      authorization_config {
#        access_point_id = aws_efs_access_point.nexus_access_point.id
#        iam             = "DISABLED"
#      }
#    }
#  }
#
#  container_definitions = jsonencode([
#    {
#      name      = "nexus",
#      image     = "088351136602.dkr.ecr.us-east-1.amazonaws.com/sonatype/nexus3:latest",
#      essential = true,
#      user      = "0",
#      cpu       = 0,
#      portMappings = [
#        {
#          name          = "nexus-8081-tcp",
#          containerPort = 8081,
#          hostPort      = 8081,
#          protocol      = "tcp",
#          appProtocol   = "http"
#        }
#      ],
#      mountPoints = [
#        {
#          sourceVolume  = "nexus-data",
#          containerPath = "/nexus-data",
#          readOnly      = false
#        }
#      ],
#      logConfiguration = {
#        logDriver = "awslogs",
#        options = {
#          awslogs-group         = "/ecs/nexus",
#          mode                  = "non-blocking",
#          awslogs-create-group  = "true",
#          max-buffer-size       = "25m",
#          awslogs-region        = "us-east-1",
#          awslogs-stream-prefix = "ecs"
#        }
#      }
#    }
#  ])
#}
#
#resource "aws_ecs_service" "nexus" {
#  name            = "nexus-service"
#  cluster         = aws_ecs_cluster.app-cluster.id
#  task_definition = aws_ecs_task_definition.nexus_with_efs.arn
#  launch_type     = "FARGATE"
#  desired_count   = 1
#
#  network_configuration {
#    subnets         = [aws_subnet.private1.id, aws_subnet.private2.id]
#    security_groups = [aws_security_group.allow_all_traffic.id]
#    assign_public_ip = false
#  }
#
#  load_balancer {
#    target_group_arn = aws_lb_target_group.nexus_target_group.arn
#    container_name   = "nexus"
#    container_port   = 8081
#  }
#
#  depends_on = [
#    aws_efs_access_point.nexus_access_point
#  ]
#}
#
#resource "aws_ecs_task_definition" "prometheus" {
#  family                   = "prometheus"
#  requires_compatibilities = ["FARGATE"]
#  cpu                      = "1024"
#  memory                   = "2048"
#  network_mode             = "awsvpc"
#  execution_role_arn       = "arn:aws:iam::088351136602:role/ecsTaskExecutionRole"
#
#  runtime_platform {
#    cpu_architecture        = "X86_64"
#    operating_system_family = "LINUX"
#  }
#
#
#  container_definitions = jsonencode([
#    {
#      name      = "prometheus",
#      image     = "088351136602.dkr.ecr.us-east-1.amazonaws.com/bitnami/prometheus",
#      essential = true,
#      user      = "0",
#      cpu       = 0,
#      portMappings = [
#        {
#          name          = "prometheus-9090-tcp",
#          containerPort = 9090,
#          hostPort      = 9090,
#          protocol      = "tcp",
#          appProtocol   = "http"
#        }
#      ],
#      logConfiguration = {
#        logDriver = "awslogs",
#        options = {
#          awslogs-group         = "/ecs/prometheus",
#          mode                  = "non-blocking",
#          awslogs-create-group  = "true",
#          max-buffer-size       = "25m",
#          awslogs-region        = "us-east-1",
#          awslogs-stream-prefix = "ecs"
#        }
#      }
#    }
#  ])
#}
#
#resource "aws_ecs_service" "prometheus" {
#  name            = "prometheus-service"
#  cluster         = aws_ecs_cluster.app-cluster.id
#  task_definition = aws_ecs_task_definition.prometheus.arn
#  launch_type     = "FARGATE"
#  desired_count   = 1
#
#  network_configuration {
#    subnets         = [aws_subnet.private1.id, aws_subnet.private2.id]
#    security_groups = [aws_security_group.allow_all_traffic.id]
#    assign_public_ip = false
#  }
#
#  load_balancer {
#    target_group_arn = aws_lb_target_group.prometheus_target_group.arn
#    container_name   = "prometheus"
#    container_port   = 9090
#  }
#}
#
#// **********************************************************************
#
#resource "aws_lb" "app-alb" {
#  name               = "app-alb"
#  internal           = false
#  load_balancer_type = "application"
#  security_groups    = [aws_security_group.allow_all_traffic.id]
#  subnets            = [aws_subnet.public1.id, aws_subnet.public2.id]
#
#  tags = {
#    Name = "app-alb"
#  }
#}
#
#
#resource "aws_lb_listener" "jenkins" {
#  load_balancer_arn = aws_lb.app-alb.arn
#  port              = 80
#  protocol          = "HTTP"
#
#  default_action {
#    type = "redirect"
#    redirect {
#      port        = "443"
#      protocol    = "HTTPS"
#      status_code = "HTTP_301"
#    }
#  }
#}
#
#
#resource "aws_lb_listener" "https" {
#  load_balancer_arn = aws_lb.app-alb.arn
#  port              = 443
#  protocol          = "HTTPS"
#  ssl_policy        = "ELBSecurityPolicy-2016-08"
#  certificate_arn   = "arn:aws:acm:us-east-1:088351136602:certificate/29950393-d61c-46e5-b482-b4beb643d7f8"
#
#  default_action {
#    type = "fixed-response"
#    fixed_response {
#      content_type = "text/plain"
#      message_body = "Not Found"
#      status_code  = "404"
#    }
#  }
#}
#
#resource "aws_lb_listener_rule" "jenkins_host_rule" {
#  listener_arn = aws_lb_listener.https.arn
#  priority     = 10
#
#  action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.jenkins_target_group.arn
#  }
#
#  condition {
#    host_header {
#      values = ["jenkins.app.dongwonlee.dev"]
#    }
#  }
#}
#
#
#resource "aws_lb_target_group" "jenkins_target_group" {
#  name        = "jenkins-target-group"
#  port        = 8080
#  protocol    = "HTTP"
#  target_type = "ip"
#  vpc_id      = aws_vpc.app-vpc.id
#
#  health_check {
#    path                = "/login"
#    protocol            = "HTTP"
#    matcher             = "200"
#    interval            = 30
#    timeout             = 5
#    healthy_threshold   = 2
#    unhealthy_threshold = 2
#  }
#
#  tags = {
#    Name = "jenkins-target-group"
#  }
#}
#
#resource "aws_lb_listener_rule" "grafana_host_rule" {
#  listener_arn = aws_lb_listener.https.arn
#  priority     = 20
#
#  action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.grafana_target_group.arn
#  }
#
#  condition {
#    host_header {
#      values = ["grafana.app.dongwonlee.dev"]
#    }
#  }
#}
#
#resource "aws_lb_target_group" "grafana_target_group" {
#  name        = "grafana-target-group"
#  port        = 3000
#  protocol    = "HTTP"
#  target_type = "ip"
#  vpc_id      = aws_vpc.app-vpc.id
#
#  health_check {
#    path                = "/api/health"
#    protocol            = "HTTP"
#    matcher             = "200"
#    interval            = 30
#    timeout             = 5
#    healthy_threshold   = 2
#    unhealthy_threshold = 2
#  }
#
#  tags = {
#    Name = "grafana-target-group"
#  }
#}
#
#resource "aws_lb_listener_rule" "sonarqube_host_rule" {
#  listener_arn = aws_lb_listener.https.arn
#  priority     = 30
#
#  action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.sonarqube_target_group.arn
#  }
#
#  condition {
#    host_header {
#      values = ["sonarqube.app.dongwonlee.dev"]
#    }
#  }
#}
#
#resource "aws_lb_target_group" "sonarqube_target_group" {
#  name        = "sonarqube-target-group"
#  port        = 9000
#  protocol    = "HTTP"
#  target_type = "ip"
#  vpc_id      = aws_vpc.app-vpc.id
#
#  health_check {
#    path                = "/"
#    protocol            = "HTTP"
#    matcher             = "200"
#    interval            = 30
#    timeout             = 5
#    healthy_threshold   = 2
#    unhealthy_threshold = 2
#  }
#
#  tags = {
#    Name = "sonarqube-target-group"
#  }
#}
#
#resource "aws_lb_listener_rule" "nexus_host_rule" {
#  listener_arn = aws_lb_listener.https.arn
#  priority     = 40
#
#  action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.nexus_target_group.arn
#  }
#
#  condition {
#    host_header {
#      values = ["nexus.app.dongwonlee.dev"]
#    }
#  }
#}
#
#resource "aws_lb_target_group" "nexus_target_group" {
#  name        = "nexus-target-group"
#  port        = 8081
#  protocol    = "HTTP"
#  target_type = "ip"
#  vpc_id      = aws_vpc.app-vpc.id
#
#  health_check {
#    path                = "/service/rest/v1/status"
#    protocol            = "HTTP"
#    matcher             = "200"
#    interval            = 30
#    timeout             = 5
#    healthy_threshold   = 2
#    unhealthy_threshold = 2
#  }
#
#  tags = {
#    Name = "nexus-target-group"
#  }
#}
#
#resource "aws_lb_listener_rule" "prometheus_host_rule" {
#  listener_arn = aws_lb_listener.https.arn
#  priority     = 50
#
#  action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.prometheus_target_group.arn
#  }
#
#  condition {
#    host_header {
#      values = ["prometheus.app.dongwonlee.dev"]
#    }
#  }
#}
#
#resource "aws_lb_target_group" "prometheus_target_group" {
#  name        = "prometheus-target-group"
#  port        = 9090
#  protocol    = "HTTP"
#  target_type = "ip"
#  vpc_id      = aws_vpc.app-vpc.id
#
#  health_check {
#    path                = "/-/healthy"
#    protocol            = "HTTP"
#    matcher             = "200"
#    interval            = 30
#    timeout             = 5
#    healthy_threshold   = 2
#    unhealthy_threshold = 2
#  }
#
#  tags = {
#    Name = "prometheus-target-group"
#  }
#}
#
#// **********************************************************************
#
#data "aws_route53_zone" "app_zone" {
#  name = "app.dongwonlee.dev"
#  private_zone = false
#}
#
#resource "aws_route53_record" "app_alb_alias" {
#  zone_id = data.aws_route53_zone.app_zone.zone_id
#  name    = "app.dongwonlee.dev"
#  type    = "A"
#
#  alias {
#    name                   = aws_lb.app-alb.dns_name
#    zone_id                = aws_lb.app-alb.zone_id
#    evaluate_target_health = true
#  }
#}
#
#resource "aws_route53_record" "app_alb_cname" {
#  zone_id = data.aws_route53_zone.app_zone.zone_id
#  name    = "*.app.dongwonlee.dev"
#  type    = "CNAME"
#  ttl     = 300
#  records = [aws_lb.app-alb.dns_name]
#}