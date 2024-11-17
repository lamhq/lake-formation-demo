# target location
resource "aws_lakeformation_resource" "target_location" {
  arn = "arn:aws:s3:::${local.bucket_prefix}/target"
  role_arn = aws_iam_role.location_role.arn
  hybrid_access_enabled = false
}
