resource "aws_iam_role" "glue_job_role" {
  name = "${local.name_prefix}-job-role"

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
}

resource "aws_iam_role_policy_attachment" "glue_job_role_policies" {
  role       = aws_iam_role.glue_job_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_role_policy" "glue_job_inline_policy" {
  role = aws_iam_role.glue_job_role.id
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
      },
      {
        Effect   = "Allow"
        Action = [
          "s3:PutObject"
        ]
        Resource = "arn:aws:s3:::${local.bucket_prefix}/target/*"
      },
    ]
  })
}

### SOURCE DB PERMISSIONS ###
resource "aws_lakeformation_permissions" "glue_job_source_location_permission" {
  principal   = aws_iam_role.glue_job_role.arn
  permissions = ["DATA_LOCATION_ACCESS"]

  data_location {
    arn = aws_lakeformation_resource.source_location.arn
  }
}

# resource "aws_lakeformation_permissions" "glue_job_source_table_permissions" {
#   principal = aws_iam_role.glue_job_role.arn
#   permissions = ["SELECT", "DESCRIBE"]
#   table {
#     database_name = aws_glue_catalog_database.source_db.name
#     name = "customers"
#   }
# }


### TARGET DB PERMISSIONS ###
# resource "aws_lakeformation_permissions" "glue_job_target_location_permission" {
#   principal   = aws_iam_role.glue_job_role.arn
#   permissions = ["DATA_LOCATION_ACCESS"]

#   data_location {
#     arn = aws_lakeformation_resource.target_location.arn
#   }
# }

resource "aws_lakeformation_permissions" "glue_job_target_db_permissions" {
  principal = aws_iam_role.glue_job_role.arn
  permissions = ["CREATE_TABLE", "DESCRIBE"]
  database {
    name = aws_glue_catalog_database.target_db.name
  }
}


### DEFAULT DB PERMISSIONS ###
resource "aws_lakeformation_permissions" "glue_job_default_db_permissions" {
  principal = aws_iam_role.glue_job_role.arn
  permissions = ["DESCRIBE"]
  database {
    name = "default"
  }
}
