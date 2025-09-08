# Author: Timothy Kornish
# CreatedDate: 9/08/2025
# Description: set up s3 bucket and folder to store docker tar file

resource "aws_s3_bucket" "tk_s3_bucket" {
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "tk_access_block" {
  bucket              = aws_s3_bucket.tk_s3_bucket.id
  block_public_acls   = true
  block_public_policy = true
}

resource "aws_s3_object" "tk_bucket_object" {
  bucket = aws_s3_bucket.tk_s3_bucket.id
  key    = var.docker_img_tar_file
  source = "../${var.docker_img_tar_file}"

  # This gets the md5 checksum of the image file and checks to see if it has
  # changed since the last apply
  etag = filemd5("../${var.docker_img_tar_file}")
}