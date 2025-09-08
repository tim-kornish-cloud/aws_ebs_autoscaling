# Author: Timothy Kornish
# CreatedDate: 9/08/2025
# Description: set up launch template for ec2 nodes

resource "aws_launch_configuration" "tk_lc" {
  image_id             = var.ami_al2_ecs
  instance_type        = "t3.micro"
  key_name             = "ebs-load-balancing"
  #security_groups      = [aws_security_group.ssh_http_only.id]
  vpc_security_group_ids = [aws_security_group.ssh_http_only.id]
  #iam_instance_profile = aws_iam_instance_profile.ec2_s3_profile.name
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_s3_profile.name
  }

  user_data = filebase64("launch_template/launch.sh")

  depends_on = [
    aws_s3_object.tk_bucket_object,
  ]
  # Required when using a launch configuration with an auto scaling group.
  # this is now deprecated, must use aws_launch_template
  # https://www.terraform.io/docs/providers/aws/r/launch_configuration.html
  lifecycle {
    create_before_destroy = true
  }

}