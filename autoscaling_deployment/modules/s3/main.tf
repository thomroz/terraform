resource "aws_s3_bucket" "thomas-terraform-codedeploy-bucket" {
  bucket = "thomas-terraform-codedeploy-bucket"
  acl    = "private"

  tags = {
    Name = "thomas-terraform-codedeploy-bucket"
  }
}

resource "aws_s3_bucket_policy" "codedeploy_upload_policy" {
  bucket = aws_s3_bucket.thomas-terraform-codedeploy-bucket.id

  policy = file("${path.module}//json/upload_policy.json")
}

resource "aws_s3_bucket_policy" "codedeploy_download_policy" {
  bucket = aws_s3_bucket.thomas-terraform-codedeploy-bucket.id

  policy = file("${path.module}/json/download_policy.json")
}
