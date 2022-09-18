resource "aws_s3_bucket" "aws-s3-raj-bucket" {
  bucket = "aws-s3-raj-bucket"

  tags = {
    Name        = "aws-s3-raj-bucket"
    Environment = "Dev"
    terraform   = "true"
  }
}

resource "aws_s3_bucket_acl" "aws-s3-raj-bucket" {
  bucket = aws_s3_bucket.aws-s3-raj-bucket.id
  acl    = "private"
}