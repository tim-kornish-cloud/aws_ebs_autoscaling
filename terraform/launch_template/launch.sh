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