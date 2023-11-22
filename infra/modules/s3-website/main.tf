resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name # My lovely website"
    Terraform   = "True"
  }
}

resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# resource "aws_s3_bucket_policy" "allow_http_access" {
#   bucket = aws_s3_bucket.this.id
#   policy = aws_iam_policy_document.this.json
# }

# data "aws_iam_policy_document" "allow_website_access" {
#   statement {
#     principals {
#       type        = "*"
#       identifiers = ["*"]
#     }

#     actions = [
#       "s3:GetObject",
#     ]

#     resources = [
#       aws_s3_bucket.this.arn,
#       "${aws_s3_bucket.this.arn}/*",
#     ]
#   }
# }
resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = [
          "${aws_s3_bucket.this.arn}/*",
          "${aws_s3_bucket.this.arn}",
        ]
      },
    ]
  })
}