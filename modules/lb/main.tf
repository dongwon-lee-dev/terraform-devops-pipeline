resource "aws_lb" "app-alb" {
  name               = "app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.aws_security_group_allow_all_traffic_id]
  subnets            = [var.aws_subnet_public1_id, var.aws_subnet_public2_id]

  tags = {
    Name = "app-alb"
  }
}


resource "aws_lb_listener" "jenkins" {
  load_balancer_arn = aws_lb.app-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}


resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.app-alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.ssl_certificate

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "jenkins_host_rule" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins_target_group.arn
  }

  condition {
    host_header {
      values = ["jenkins.${var.domain_name}"]
    }
  }
}


resource "aws_lb_target_group" "jenkins_target_group" {
  name        = "jenkins-target-group"
  port        = 8080
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.aws_vpc_app_vpc_id

  health_check {
    path                = "/login"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "jenkins-target-group"
  }
}

resource "aws_lb_listener_rule" "grafana_host_rule" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grafana_target_group.arn
  }

  condition {
    host_header {
      values = ["grafana.${var.domain_name}"]
    }
  }
}

resource "aws_lb_target_group" "grafana_target_group" {
  name        = "grafana-target-group"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.aws_vpc_app_vpc_id

  health_check {
    path                = "/api/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "grafana-target-group"
  }
}

resource "aws_lb_listener_rule" "sonarqube_host_rule" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 30

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sonarqube_target_group.arn
  }

  condition {
    host_header {
      values = ["sonarqube.${var.domain_name}"]
    }
  }
}

resource "aws_lb_target_group" "sonarqube_target_group" {
  name        = "sonarqube-target-group"
  port        = 9000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.aws_vpc_app_vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "sonarqube-target-group"
  }
}

resource "aws_lb_listener_rule" "nexus_host_rule" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 40

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nexus_target_group.arn
  }

  condition {
    host_header {
      values = ["nexus.${var.domain_name}"]
    }
  }
}

resource "aws_lb_target_group" "nexus_target_group" {
  name        = "nexus-target-group"
  port        = 8081
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.aws_vpc_app_vpc_id

  health_check {
    path                = "/service/rest/v1/status"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 120
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "nexus-target-group"
  }
}

resource "aws_lb_listener_rule" "prometheus_host_rule" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 50

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prometheus_target_group.arn
  }

  condition {
    host_header {
      values = ["prometheus.${var.domain_name}"]
    }
  }
}

resource "aws_lb_target_group" "prometheus_target_group" {
  name        = "prometheus-target-group"
  port        = 9090
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.aws_vpc_app_vpc_id

  health_check {
    path                = "/-/healthy"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "prometheus-target-group"
  }
}