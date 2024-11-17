# source location
resource "aws_lakeformation_resource" "source_location" {
  arn = "arn:aws:s3:::${local.bucket_prefix}/source"
  role_arn = aws_iam_role.location_role.arn
  hybrid_access_enabled = false
}
