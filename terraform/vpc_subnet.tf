# Author: Timothy Kornish
# CreatedDate: 9/08/2025
# Description: set up an extremely basic vpc with subnet

# Default VPC
# data resources allow you to get information about infrastructure components
# that already exist. These data objects get the default VPC and subnets that
# AWS creates for all accounts.

# create a data list of availability zones
data "aws_availability_zones" "default_vpc_available" {
  state = "available"
}

# create a data variable to retreive the current region
# region = "us-east-1"
data "aws_region" "current" {}

resource  "aws_vpc" "default_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
}

resource "aws_subnet" "default_subnet" {
  vpc_id = aws_vpc.default_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}


resource "aws_subnet" "secondary_subnet" {
  vpc_id = aws_vpc.default_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

# create internet gateway
resource "aws_internet_gateway" "default_igw" {
  vpc_id = aws_vpc.default_vpc.id
  tags = {
    Name = "LoadBalancingInternetGateway"
  }
}

# create a route table for the vpc IPs
resource "aws_route_table" "default_vpc_route_table" {
  vpc_id = aws_vpc.default_vpc.id
  route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.default_igw.id
      }
  tags = {
    Name = "public-route-table"
  }
}

# create a route table association to each subnet
resource "aws_route_table_association" "default_public_subnet_association" {
  subnet_id      = aws_subnet.default_subnet.id
  route_table_id = aws_route_table.default_vpc_route_table.id
}

# create a route table association to each subnet
resource "aws_route_table_association" "default_public_gateway_association" {
  gateway_id     = aws_internet_gateway.default_igw.id
  route_table_id = aws_route_table.default_vpc_route_table.id
}

# create a vpc gateway endpoint pointing towards the s3 bucket
resource "aws_vpc_endpoint" "default_vpc_s3_gateway_endpoint" {
  vpc_id       = aws_vpc.default_vpc.id
  service_name = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [
    aws_route_table.default_vpc_route_table.id
  ]

  # Add a policy to restrict access to specific S3 buckets
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Principal = "*"
        Action   = "s3:*"
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.tk_s3_bucket.id}",
          "arn:aws:s3:::${aws_s3_bucket.tk_s3_bucket.id}/*",
        ]
      },
    ]
  })

  tags = {
    Name = "default-s3-gateway-endpoint"
  }
}

