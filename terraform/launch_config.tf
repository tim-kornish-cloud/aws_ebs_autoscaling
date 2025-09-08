# Author: Timothy Kornish
# CreatedDate: 9/08/2025
# Description: set up launch configuration for ec2 nodes

resource "aws_launch_configuration" "tk_lc" {
  image_id             = var.ami_al2_ecs
  instance_type        = "t3.micro"
  key_name             = "ebs-load-balancing"
  security_groups      = [aws_security_group.ssh_http_only.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_s3_profile.name

  user_data = <<EOF
#!/bin/bash
sudo yum update -y
sudo yum install -y unzip

# Install aws cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Fetch docker image
aws s3 cp s3://${aws_s3_bucket.tk_s3_bucket.id}/${aws_s3_object.tk_bucket_object.id} .

# Load and run image
docker load -i ./${aws_s3_object.tk_bucket_object.id}
docker run -dp 80:80 ${var.docker_img_tag}

# Cleanup
rm awscliv2.zip
rm ${aws_s3_object.tk_bucket_object.id}
EOF

  depends_on = [
    aws_s3_object.tk_bucket_object,
  ]
  # Required when using a launch configuration with an auto scaling group.
  # https://www.terraform.io/docs/providers/aws/r/launch_configuration.html
  lifecycle {
    create_before_destroy = true
  }

}