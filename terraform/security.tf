# Author: Timothy Kornish
# CreatedDate: 9/08/2025
# Description: set up security group to only allow ssh and http access

resource "aws_security_group" "ssh_http_only" {
  name        = "ssh_http_only"
  description = "Allow ssh and http access"

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }
}