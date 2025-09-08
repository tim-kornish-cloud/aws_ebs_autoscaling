# Author: Timothy Kornish
# CreatedDate: 9/08/2025
# Description: set up console output to log the dns name of the load balancer

# output dns of load balancer
output "dns_name" {
  value = aws_lb.tk_lb.dns_name
}

