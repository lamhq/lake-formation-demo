resource "aws_iam_role" "customer_crawler_role" {
  name = "${local.name_prefix}-customer-crawler-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "glue.amazonaws.com"
      }
    }]
  })

  tags = local.role_tags
}

resource "aws_iam_role_policy_attachment" "customer_crawler_role_policies" {
  role       = aws_iam_role.customer_crawler_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_role_policy" "customer_crawler_inline_policy" {
  role = aws_iam_role.customer_crawler_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action = [
          "lakeformation:GetDataAccess",
          "lakeformation:GrantPermissions"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_lakeformation_permissions" "customer_crawler_source_location_permission" {
  principal   = aws_iam_role.customer_crawler_role.arn
  permissions = ["DATA_LOCATION_ACCESS"]

  data_location {
    arn = aws_lakeformation_resource.source_location.arn
  }
}

resource "aws_lakeformation_permissions" "customer_crawler_catalog_permissions" {
  principal = aws_iam_role.customer_crawler_role.arn
  permissions = ["CREATE_TABLE"]
  database {
    name = aws_glue_catalog_database.source_db.name
  }
}

resource "aws_glue_crawler" "customer_crawler" {
  database_name = aws_glue_catalog_database.source_db.name
  name          = "${local.name_prefix}-customer-crawler"
  role          = aws_iam_role.customer_crawler_role.arn

  lake_formation_configuration {
    use_lake_formation_credentials = true
  }

  s3_target {
    path = "s3://${local.bucket_prefix}/source/customers"
  }

  s3_target {
    path = "s3://${local.bucket_prefix}/source/products"
  }

  schema_change_policy {
    delete_behavior = "DELETE_FROM_DATABASE"
    update_behavior = "UPDATE_IN_DATABASE"
  }
}