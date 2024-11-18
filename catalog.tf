# source database
resource "aws_glue_catalog_database" "source_db" {
  name = "${local.name_prefix}-source"
}

# target database
resource "aws_glue_catalog_database" "target_db" {
  name = "${local.name_prefix}-target"
}

# IAM role for all data lake locations
resource "aws_iam_role" "location_role" {
  name = "${local.name_prefix}-location-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lakeformation.amazonaws.com"
      }
    }]
  })

  tags = local.role_tags
}

# location role policy
resource "aws_iam_role_policy" "location_role_inline_policy" {
  role = aws_iam_role.location_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject"
        ]
        Resource = "arn:aws:s3:::${local.bucket_prefix}/source/*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "arn:aws:s3:::${local.bucket_prefix}/target/*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = "arn:aws:s3:::${var.artifact_bucket}"
      }
    ]
  })
}
