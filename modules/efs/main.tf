resource "aws_efs_file_system" "app_efs_data" {
  creation_token = "app_efs_data"
  tags = {
    Name = "app_efs_data"
  }
}

resource "aws_efs_mount_target" "private1" {
  file_system_id  = aws_efs_file_system.app_efs_data.id
  subnet_id       = var.aws_subnet_private1_id
  security_groups = [var.aws_security_group_allow_all_traffic_id]
}

resource "aws_efs_mount_target" "private2" {
  file_system_id  = aws_efs_file_system.app_efs_data.id
  subnet_id       = var.aws_subnet_private2_id
  security_groups = [var.aws_security_group_allow_all_traffic_id]
}

resource "aws_efs_access_point" "jenkins_access_point" {
  file_system_id = aws_efs_file_system.app_efs_data.id

  posix_user {
    uid = 0
    gid = 0
  }

  root_directory {
    path = "/jenkins"
    creation_info {
      owner_uid   = 0
      owner_gid   = 0
      permissions = "0777"
    }
  }

  tags = {
    Name = "jenkins-access-point"
  }
}

resource "aws_efs_access_point" "grafana_access_point" {
  file_system_id = aws_efs_file_system.app_efs_data.id

  posix_user {
    uid = 1000
    gid = 1000
  }

  root_directory {
    path = "/grafana"
    creation_info {
      owner_uid   = 1000
      owner_gid   = 1000
      permissions = "0777"
    }
  }

  tags = {
    Name = "grafana-access-point"
  }
}

resource "aws_efs_access_point" "sonarqube_access_point" {
  file_system_id = aws_efs_file_system.app_efs_data.id

  posix_user {
    uid = 1000
    gid = 1000
  }

  root_directory {
    path = "/sonarqube"
    creation_info {
      owner_uid   = 1000
      owner_gid   = 1000
      permissions = "0777"
    }
  }

  tags = {
    Name = "sonarqube-access-point"
  }
}

resource "aws_efs_access_point" "nexus_access_point" {
  file_system_id = aws_efs_file_system.app_efs_data.id

  posix_user {
    uid = 1000
    gid = 1000
  }

  root_directory {
    path = "/nexus"
    creation_info {
      owner_uid   = 1000
      owner_gid   = 1000
      permissions = "0777"
    }
  }

  tags = {
    Name = "nexus-access-point"
  }
}

