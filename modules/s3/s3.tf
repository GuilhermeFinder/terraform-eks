resource "aws_kms_key" "terraform_tfstate" {
  description             = "Key used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "terraform_tfstate" {
  bucket = "tfstate-click-bucket"
}

resource "aws_s3_bucket_acl" "terraform_tfstate" {
  bucket = aws_s3_bucket.terraform_tfstate.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "terraform_tfstate" {
  bucket = aws_s3_bucket.terraform_tfstate.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_tfstate" {
  bucket = aws_s3_bucket.terraform_tfstate.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_tfstate" {
  bucket = aws_s3_bucket.terraform_tfstate.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.terraform_tfstate.arn
      sse_algorithm     = "aws:kms"
    }
  }
}