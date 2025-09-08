# Author: Timothy Kornish
# CreatedDate: 9/08/2025
# Description: set up an extremely basic vpc with subnet

# Default VPC
# data resources allow you to get information about infrastructure components
# that already exist. These data objects get the default VPC and subnets that
# AWS creates for all accounts.
resource  "aws_vpc" "default_vpc" {}

data "aws_subnet" "default_subnet" {
  vpc_id = aws_vpc.default_vpc.id
  # filter {
  #   name   = "vpc-id"
  #   values = [data.aws_default_vpc.default_vpc.id]
  # }
}