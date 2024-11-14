# lake formation database
resource "aws_glue_catalog_database" "bronze_db" {
  name = "${local.name_prefix}-bronze"
}

# register a data lake location
resource "aws_lakeformation_resource" "customer_location" {
  arn = "arn:aws:s3:::${var.artifact_bucket}/lf-demo/dev/raw/customers/"
  role_arn = aws_iam_role.location_role.arn
}

# data lake location role
resource "aws_iam_role" "location_role" {
  name = "${local.name_prefix}-localtion-role"

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
}

# data lake location role policy
resource "aws_iam_role_policy" "location_role_inline_policy" {
  role = aws_iam_role.location_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "arn:aws:s3:::${var.artifact_bucket}/${var.project}/${local.env}/raw/customers/*"
      },
      {
        Effect   = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = "arn:aws:s3:::${var.artifact_bucket}"
      }    
    ]
  })
}
