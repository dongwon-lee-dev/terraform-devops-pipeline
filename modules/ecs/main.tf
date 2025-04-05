resource "aws_ecs_cluster" "app-cluster" {
  name = "app-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "jenkins_master_with_efs" {
  family                   = "jenkins-master"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "2048"
  memory                   = "4096"
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_task_execution_role_arn

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  volume {
    name = "jenkins-data"
    efs_volume_configuration {
      file_system_id     = var.aws_efs_file_system_app_efs_data_id
      root_directory     = "/"
      transit_encryption = "ENABLED"
      authorization_config {
        access_point_id = var.aws_efs_access_point_jenkins_access_point_id
        iam             = "DISABLED"
      }
    }
  }

  container_definitions = jsonencode([
    {
      name      = "jenkins",
      image     = var.jenkins_image,
      essential = true,
      user      = "1000",
      cpu       = 0,
      portMappings = [
        {
          name          = "jenkins-8080-tcp",
          containerPort = 8080,
          hostPort      = 8080,
          protocol      = "tcp",
          appProtocol   = "http"
        }
      ],
      mountPoints = [
        {
          sourceVolume  = "jenkins-data",
          containerPath = "/var/jenkins_home",
          readOnly      = false
        }
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = "/ecs/jenkins-master",
          mode                  = "non-blocking",
          awslogs-create-group  = "true",
          max-buffer-size       = "25m",
          awslogs-region        = "us-east-1",
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "jenkins" {
  name            = "jenkins-service"
  cluster         = aws_ecs_cluster.app-cluster.id
  task_definition = aws_ecs_task_definition.jenkins_master_with_efs.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = [var.aws_subnet_private1_id, var.aws_subnet_private2_id]
    security_groups  = [var.aws_security_group_allow_all_traffic_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.aws_lb_target_group_jenkins_target_group_arn
    container_name   = "jenkins"
    container_port   = 8080
  }

  depends_on = [
    var.aws_efs_access_point_jenkins_access_point
  ]

}

resource "aws_appautoscaling_target" "jenkins" {
  max_capacity       = 3
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.app-cluster.name}/${aws_ecs_service.jenkins.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "jenkins_cpu_scale_out" {
  name               = "scale-out"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.jenkins.resource_id
  scalable_dimension = aws_appautoscaling_target.jenkins.scalable_dimension
  service_namespace  = aws_appautoscaling_target.jenkins.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = 60
    scale_out_cooldown = 30
    scale_in_cooldown  = 60
  }
}


resource "aws_ecs_task_definition" "grafana_with_efs" {
  family                   = "grafana"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "2048"
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_task_execution_role_arn

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  volume {
    name = "grafana-data"
    efs_volume_configuration {
      file_system_id     = var.aws_efs_file_system_app_efs_data_id
      root_directory     = "/"
      transit_encryption = "ENABLED"
      authorization_config {
        access_point_id = var.aws_efs_access_point_grafana_access_point_id
        iam             = "DISABLED"
      }
    }
  }

  container_definitions = jsonencode([
    {
      name      = "grafana",
      image     = var.grafana_image,
      essential = true,
      user      = "1000",
      cpu       = 0,
      portMappings = [
        {
          name          = "grafana-3000-tcp",
          containerPort = 3000,
          hostPort      = 3000,
          protocol      = "tcp",
          appProtocol   = "http"
        }
      ],
      mountPoints = [
        {
          sourceVolume  = "grafana-data",
          containerPath = "/var/lib/grafana",
          readOnly      = false
        }
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = "/ecs/grafana",
          mode                  = "non-blocking",
          awslogs-create-group  = "true",
          max-buffer-size       = "25m",
          awslogs-region        = "us-east-1",
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "grafana" {
  name            = "grafana-service"
  cluster         = aws_ecs_cluster.app-cluster.id
  task_definition = aws_ecs_task_definition.grafana_with_efs.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = [var.aws_subnet_private1_id, var.aws_subnet_private2_id]
    security_groups  = [var.aws_security_group_allow_all_traffic_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.aws_lb_target_group_grafana_target_group_arn
    container_name   = "grafana"
    container_port   = 3000
  }

  depends_on = [
    var.aws_efs_access_point_grafana_access_point
  ]

}

resource "aws_appautoscaling_target" "grafana" {
  max_capacity       = 3
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.app-cluster.name}/${aws_ecs_service.grafana.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "grafana_cpu_scale_out" {
  name               = "scale-out"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.grafana.resource_id
  scalable_dimension = aws_appautoscaling_target.grafana.scalable_dimension
  service_namespace  = aws_appautoscaling_target.grafana.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = 60
    scale_out_cooldown = 30
    scale_in_cooldown  = 60
  }
}

resource "aws_ecs_task_definition" "sonarqube_with_efs" {
  family                   = "sonarqube"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "2048"
  memory                   = "4096"
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_task_execution_role_arn

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  volume {
    name = "sonarqube-data"
    efs_volume_configuration {
      file_system_id     = var.aws_efs_file_system_app_efs_data_id
      root_directory     = "/"
      transit_encryption = "ENABLED"
      authorization_config {
        access_point_id = var.aws_efs_access_point_sonarqube_access_point_id
        iam             = "DISABLED"
      }
    }
  }

  container_definitions = jsonencode([
    {
      name      = "sonarqube",
      image     = var.sonarqube_image,
      essential = true,
      user      = "1000",
      cpu       = 0,
      portMappings = [
        {
          name          = "sonarqube-9000-tcp",
          containerPort = 9000,
          hostPort      = 9000,
          protocol      = "tcp",
          appProtocol   = "http"
        }
      ],
      mountPoints = [
        {
          sourceVolume  = "sonarqube-data",
          containerPath = "/opt/sonarqube/data",
          readOnly      = false
        }
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = "/ecs/sonarqube",
          mode                  = "non-blocking",
          awslogs-create-group  = "true",
          max-buffer-size       = "25m",
          awslogs-region        = "us-east-1",
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "sonarqube" {
  name            = "sonarqube-service"
  cluster         = aws_ecs_cluster.app-cluster.id
  task_definition = aws_ecs_task_definition.sonarqube_with_efs.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = [var.aws_subnet_private1_id, var.aws_subnet_private2_id]
    security_groups  = [var.aws_security_group_allow_all_traffic_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.aws_lb_target_group_sonarqube_target_group_arn
    container_name   = "sonarqube"
    container_port   = 9000
  }

  depends_on = [
    var.aws_efs_access_point_sonarqube_access_point
  ]

}

resource "aws_ecs_task_definition" "nexus_with_efs" {
  family                   = "nexus"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "2048"
  memory                   = "4096"
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_task_execution_role_arn

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  volume {
    name = "nexus-data"
    efs_volume_configuration {
      file_system_id     = var.aws_efs_file_system_app_efs_data_id
      root_directory     = "/"
      transit_encryption = "ENABLED"
      authorization_config {
        access_point_id = var.aws_efs_access_point_nexus_access_point_id
        iam             = "DISABLED"
      }
    }
  }

  container_definitions = jsonencode([
    {
      name      = "nexus",
      image     = var.nexus_image,
      essential = true,
      user      = "1000",
      cpu       = 0,
      portMappings = [
        {
          name          = "nexus-8081-tcp",
          containerPort = 8081,
          hostPort      = 8081,
          protocol      = "tcp",
          appProtocol   = "http"
        }
      ],
      mountPoints = [
        {
          sourceVolume  = "nexus-data",
          containerPath = "/nexus-data",
          readOnly      = false
        }
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = "/ecs/nexus",
          mode                  = "non-blocking",
          awslogs-create-group  = "true",
          max-buffer-size       = "25m",
          awslogs-region        = "us-east-1",
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "nexus" {
  name            = "nexus-service"
  cluster         = aws_ecs_cluster.app-cluster.id
  task_definition = aws_ecs_task_definition.nexus_with_efs.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = [var.aws_subnet_private1_id, var.aws_subnet_private2_id]
    security_groups  = [var.aws_security_group_allow_all_traffic_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.aws_lb_target_group_nexus_target_group_arn
    container_name   = "nexus"
    container_port   = 8081
  }

  depends_on = [
    var.aws_efs_access_point_nexus_access_point
  ]
}

resource "aws_ecs_task_definition" "prometheus" {
  family                   = "prometheus"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "2048"
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_task_execution_role_arn

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name      = "prometheus",
      image     = var.prometheus_image,
      essential = true,
      user      = "0",
      cpu       = 0,
      portMappings = [
        {
          name          = "prometheus-9090-tcp",
          containerPort = 9090,
          hostPort      = 9090,
          protocol      = "tcp",
          appProtocol   = "http"
        }
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = "/ecs/prometheus",
          mode                  = "non-blocking",
          awslogs-create-group  = "true",
          max-buffer-size       = "25m",
          awslogs-region        = "us-east-1",
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "prometheus" {
  name            = "prometheus-service"
  cluster         = aws_ecs_cluster.app-cluster.id
  task_definition = aws_ecs_task_definition.prometheus.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = [var.aws_subnet_private1_id, var.aws_subnet_private2_id]
    security_groups  = [var.aws_security_group_allow_all_traffic_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.aws_lb_target_group_prometheus_target_group_arn
    container_name   = "prometheus"
    container_port   = 9090
  }
}