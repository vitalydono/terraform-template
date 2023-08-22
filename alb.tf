############################################
#            load balancer
############################################

resource "aws_lb" "cltt_alb" {
  name               = "cltt-alb"
  load_balancer_type = "application"
  subnets            = [aws_subnet.cltt_public_subnet.id, aws_subnet.cltt_public_subnet_for_alb.id]
  security_groups    = [aws_security_group.cltt_sg.id]
  tags = {
    Name = "cltt_alb"
  }
}

############################################
#            target groups
############################################

resource "aws_lb_target_group" "cltt_dev_target_group" {
  name     = "cltt-dev-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.cltt_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
  }
}

resource "aws_lb_target_group" "cltt_prod_web_target_group" {
  name     = "cltt-prod-web-target-group"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = aws_vpc.cltt_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTPS"
    interval            = 30
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
  }
}

############################################
#            listeners
############################################

resource "aws_lb_listener" "cltt_listener_http" {
  load_balancer_arn = aws_lb.cltt_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.cltt_dev_target_group.arn
    type             = "redirect"
    redirect {
      protocol    = "HTTPS"
      port        = "443"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "cltt_listener_https" {
  load_balancer_arn = aws_lb.cltt_alb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn

  default_action {
    target_group_arn = aws_lb_target_group.cltt_prod_web_target_group.arn
    type             = "forward"
  }
}

############################################
#            target group attachment
############################################

resource "aws_lb_target_group_attachment" "cltt_aws_lb_dev_target_group_attachment" {
  target_group_arn = aws_lb_target_group.cltt_dev_target_group.arn
  target_id        = aws_instance.cltt_ec2_dev.id
}

resource "aws_lb_target_group_attachment" "cltt_aws_lb_prod_web_target_group_attachment" {
  target_group_arn = aws_lb_target_group.cltt_prod_web_target_group.arn
  target_id        = aws_instance.cltt_ec2_prod_web.id
}

############################################
#            alb listener rules
############################################

resource "aws_lb_listener_rule" "cltt_dev_listener_rule" {
  listener_arn = aws_lb_listener.cltt_listener_https.arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cltt_dev_target_group.arn
  }
  condition {
    host_header {
      values = ["dev.d-expert.com"]
    }
  }
}

resource "aws_lb_listener_rule" "cltt_prod_listener_rule" {
  listener_arn = aws_lb_listener.cltt_listener_https.arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cltt_prod_web_target_group.arn
  }
  condition {
    host_header {
      values = ["prod.d-expert.com"]
    }
  }
}

# resource "aws_lb_listener_rule" "url_redirect_rule_default" {
#   listener_arn = aws_lb_listener.cltt_listener_https.arn
#   action {
#     type = "fixed-response"
#     fixed_response {
#       content_type = "text/plain"
#       message_body = "Service Unavailable"
#       status_code  = "503"
#     }
#   }

#   condition {
#     http_header {
#       http_header_name  = "host"
#       values            = [""]  
#     }
#   }
# }