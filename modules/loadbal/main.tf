resource "aws_lb" "this" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"

  security_groups = var.alb_sgroups
  subnets         = var.alb_subnets
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_listener_rule" "http_health" {
  listener_arn = aws_lb_listener.http.arn

  condition {
    path_pattern {
      values = ["/health", "/check"]
    }
  }

  action {
    type = "fixed-response"
    fixed_response {
      content_type = "application/json"
      message_body = jsonencode({ status = "ok" })
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener_rule" "http_ping" {
  listener_arn = aws_lb_listener.http.arn

  condition {
    path_pattern {
      values = ["/ping"]
    }
  }

  action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "/pong"
      status_code  = "200"
    }
  }
}

resource "aws_lb_target_group" "this" {
  name     = var.tg_name
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  deregistration_delay = 30

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 10
    timeout             = 5

    matcher = "200"
  }
}