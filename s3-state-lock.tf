/* resource "aws_s3_bucket" "state-lock" {
  bucket = "my-state-lock-bucket-for-innovatemart"

  tags = {
    Name        = "My bucket"
    Environment = "prod"
  }
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.state-lock.id
  versioning_configuration {
    status = "Enabled"
  }
} */
