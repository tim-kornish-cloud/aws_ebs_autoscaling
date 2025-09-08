# Author: Timothy Kornish
# CreatedDate: 9/08/2025
# Description: set up an autoscaling group for the ebs configuration

resource "aws_autoscaling_group" "tk_autoscale_group" {
  launch_configuration = aws_launch_configuration.tk_lc.name
  vpc_zone_identifier  = [aws_subnet.default_subnet.id]
  target_group_arns    = [aws_lb_target_group.tk_lb_target_group.arn]
  health_check_type    = "ELB"
  min_size             = var.min_size
  max_size             = var.max_size
  desired_capacity     = var.desired_size
  lifecycle {
    create_before_destroy = true
  }
}