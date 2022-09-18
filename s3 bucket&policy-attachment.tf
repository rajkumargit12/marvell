# resource "aws_s3_bucket" "cicd-s3-bucket" {
#   bucket = "cicd-s3-artifactroy"

#   tags = {
#     Name        = "My Bucket"
#     Environment = "Dev"
#   }
# }
resource "aws_iam_role" "cicd" {
  name = "artifactoy-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "artifactroy-role"
  }
}
resource "aws_iam_policy" "cicd" {
  name        = "cicd-policy"
  path        = "/"
  description = "My test policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
resource "aws_iam_policy_attachment" "cicd" {
  name = "s3-attachment-cicd"

  roles = [aws_iam_role.cicd.name]

  policy_arn = aws_iam_policy.cicd.arn
}







resource "aws_iam_instance_profile" "cicd" {
  name = "cicd-profile"
  role = aws_iam_role.cicd.name
}
