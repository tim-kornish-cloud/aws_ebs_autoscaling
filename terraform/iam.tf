# Author: Timothy Kornish
# CreatedDate: 9/08/2025
# Description: set up IAM role and policies

resource "aws_iam_policy" "ec2_s3_policy" {
  description = "Policy to give s3 permission to ec2"
  policy      = file("policies/s3-policy.json")
}
resource "aws_iam_role" "ec2_s3_role" {
  assume_role_policy = file("roles/s3-role.json")
}
resource "aws_iam_role_policy_attachment" "ec2_s3_role_policy_attachment" {
  role       = aws_iam_role.ec2_s3_role.name
  policy_arn = aws_iam_policy.ec2_s3_policy.arn
}
resource "aws_iam_instance_profile" "ec2_s3_profile" {
  role = aws_iam_role.ec2_s3_role.name
}