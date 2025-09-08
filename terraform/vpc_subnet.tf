# Author: Timothy Kornish
# CreatedDate: 9/08/2025
# Description: set up an extremely basic vpc with subnet

# Default VPC
# data resources allow you to get information about infrastructure components
# that already exist. These data objects get the default VPC and subnets that
# AWS creates for all accounts.
resource  "aws_vpc" "default_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
}

resource "aws_subnet" "default_subnet" {
  vpc_id = aws_vpc.default_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  # filter {
  #   name   = "vpc-id"
  #   values = [data.aws_default_vpc.default_vpc.id]
  # }
}

resource "aws_subnet" "secondary_subnet" {
  vpc_id = aws_vpc.default_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  # filter {
  #   name   = "vpc-id"
  #   values = [data.aws_default_vpc.default_vpc.id]
  # }
}

# resource "aws_subnet" "emr_public_subnet" {
#   for each loop to create a subnet for each area in region
#   for_each          = toset(data.aws_availability_zones.emr_vpc_available.names)
#   for_each          = toset(["us-east-1a", "us-east-1b"])
#   vpc_id            = aws_vpc.emr_vpc.id
#   cidr_block        = cidrsubnet(aws_vpc.emr_vpc.cidr_block, 8, index(data.aws_availability_zones.emr_vpc_available.names, each.value))
#   availability_zone = each.key
#   map_public_ip_on_launch = true
#   tags = {
#     Name = "public-subnet-${each.key}"
#     "for-use-with-amazon-emr-managed-policies" = "true"
#   }
# }