# Author: Timothy Kornish
# CreatedDate: 9/08/2025
# Description: set up an load balancer to disperse traffic across nodes avoiding bottlenecks


resource "aws_lb" "tk_lb" {
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ssh_http_only.id]
  subnets            = [aws_subnet.default_subnet.id, aws_subnet.secondary_subnet.id]
}

resource "aws_lb_target_group" "tk_lb_target_group" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.default_vpc.id
  health_check {
    path                = "/"
    port                = "traffic-port"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 5
    matcher             = "200"
  }
}

resource "aws_lb_listener" "tk_lb_listener" {
  load_balancer_arn = aws_lb.tk_lb.id
  port              = 80
  protocol          = "HTTP"
  depends_on        = [aws_lb_target_group.tk_lb_target_group]
  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}
resource "aws_lb_listener_rule" "tk_lb_listener_rule" {
  listener_arn = aws_lb_listener.tk_lb_listener.arn
  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tk_lb_target_group.arn
  }
}