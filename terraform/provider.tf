# Author: Timothy Kornish
# CreatedDate: 9/08/2025
# Description: set up terraform provider blocks and store the terraform state file in an s3 bucket

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
    region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "tk-bucketto-for-tfstate"
    key    = "PROD/terraform.tfstate"
    region = "us-east-1"
    use_lockfile = true
    #dynamodb_table = "my-state-lock-table"
  }
}