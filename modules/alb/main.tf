resource "aws_lb" "wordpress" {
  name               = "${var.env}-wordpress-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.public_subnets
  enable_deletion_protection = true
  drop_invalid_header_fields = true
dynamic "access_logs" {
  for_each = var.access_logs_bucket != null ? [1] : []
  content {
    bucket  = var.access_logs_bucket
    prefix  = var.env
    enabled = true
  }
}

  # access_logs {
  #   bucket  = var.access_logs_bucket
  #   prefix  = var.env
  #   enabled = true
  # }
  tags = {
    Name = "${var.env}-wordpress-alb"
  }
}

resource "aws_lb_target_group" "wordpress" {
  name        = "${var.env}-wordpress-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }
}

resource "aws_lb_listener" "wordpress" {
  load_balancer_arn = aws_lb.wordpress.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress.arn
  }
}